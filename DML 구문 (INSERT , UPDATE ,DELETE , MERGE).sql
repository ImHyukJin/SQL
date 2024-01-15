--INSERT의 2가지 문법

--테이블 구조를 빠르게 확인하는 방법
DESC DEPARTMENTS;

SELECT * FROM DEPARTMENTS;
--1ST (컬럼을 정확하게 일치시키는 경우는 컬럼명 생략이 가능)
INSERT INTO DEPARTMENTS VALUES(280, '개발자', NULL, 1700);

--DML문은 트랜잭션이 항상 적용됩니다
ROLLBACK;

--2ND (컬럼을 지칭해서 넣는 경우)
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID) VALUES(280, '개발자', 1700);

--넣어보기
INSERT INTO DEPARTMENTS VALUES(290, '디자이너', NULL, 1700);
INSERT INTO DEPARTMENTS VALUES(300, 'DB관리자', NULL, 1800);
INSERT INTO DEPARTMENTS VALUES(310, '데이터분석가', NULL, 1800);
INSERT INTO DEPARTMENTS VALUES(320, '퍼블리셔', NULL, 1800);
INSERT INTO DEPARTMENTS VALUES(330, '서버관리자', NULL, 1800);

---
--INSERT문에도 서브쿼리가 사용됩니다.
--실습을 위한 가짜테이블 생성
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2); --구조만 복사하는 테이블생성( 데이터X )

SELECT * FROM EMPS;
DESC EMPS;
--1ST
--모든 컬럼을 서브쿼리 절로 넣을때
INSERT INTO EMPS(SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN');
--특정 컬럼을 서브쿼리 절로 넣을때
INSERT INTO EMPS(LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
                (SELECT LAST_NAME, EMAIL, HIRE_DATE, JOB_ID FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN');
--2ND
INSERT INTO EMPS(LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES((SELECT LAST_NAME FROM EMPLOYEES WHERE MANAGER_ID IS NULL),
        'TEST01',
        SYSDATE,
        'TEST03'
    );
    
SELECT * FROM EMPS;
------------------------------------------------------------------------
COMMIT;

SELECT * FROM EMPS;
-- 114번 급여를 10% 인상
UPDATE EMPS SET SALARY = SALARY * 1.1 WHERE EMPLOYEE_ID = 114;

-- WHERE절 없이 구문을 실행시키면, 전체 테이블에 적용되기 때문에 항상 WHERE절을 붙여야 합니다.
-- 그래서 항상, SELECT문으로 업데이트할 값을 확인하고, 적용하는 습관
UPDATE EMPS SET SALARY = 0;
ROLLBACK;

-- 여러행 업데이트
UPDATE EMPS SET SALARY = SALARY * 1.1
                ,COMMISSION_PCT = 0.5
                ,MANAGER_ID = 110
WHERE EMPLOYEE_ID = 114;

--UPDATE문의 서브쿼리절
--1ST
--여러컬럼을 한번에 서브쿼리로 업데이트 하는 구문
SELECT * FROM EMPS;

UPDATE EMPS 
SET (MANAGER_ID, JOB_ID, DEPARTMENT_ID)
 = (SELECT MANAGER_ID, JOB_ID, DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201)
WHERE EMPLOYEE_ID = 114;
--각 컬럼을 서브쿼리로 업데이트 하는 구문
UPDATE EMPS
SET MANAGER_ID = (SELECT MANAGER_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201),
    JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201)
WHERE EMPLOYEE_ID = 114;
--WHERE절에도 적용이 됩니다.
UPDATE EMPS
SET SALARY = 0
WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');

------------------------------------------
--DELETE문
--삭제하기 전에 꼭, SELECT문으로 삭제키워드를 확인하는 습관을 들이자 (꼭 PK값으로 지정하세요)
SELECT * FROM EMPS WHERE EMPLOYEE_ID = 114;

DELETE FROM EMPS WHERE EMPLOYEE_ID = 114;
DELETE FROM EMPS WHERE JOB_ID LIKE '%MAN';
--DELETE서브쿼리절
DELETE FROM EMPS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPS WHERE EMPLOYEE_ID = 145); --80번 부서

----------------------------------------------------------------------------------
--DELETE문은 반드시 전부 지워지는것은 아닙니다.
--테이블이 연관관계 가지고 있으면, 참조무결성제약에 위배되는 경우, 지워지지 않습니다.
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
 
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 20; --20번 부서는 EMPLOTEE에서 참조되고 있기 때문에 삭제되지 않습니다.


---------------------------------------------
--MERGE문장 : 데이터가 있으면 UPDATE, 없으면 INSERT 문장을 수행하는 , 병합구문
UPDATE EMPS SET SALARY = 0;
DELETE FROM EMPS WHERE JOB_ID = 'SA_MAN';
SELECT * FROM EMPS;

--1ST
MERGE INTO EMPS E1 -- 타겟테이블
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN') E2 --병합할 서브쿼리
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID) -- 조인 조건
WHEN MATCHED THEN -- 일치할 때 업데이트
     UPDATE SET E1.SALARY = E2.SALARY,
                E1.COMMISSION_PCT = E2.COMMISSION_PCT
WHEN NOT MATCHED THEN -- 일치하지 않을 때 인서트
    INSERT (EMPLOYEE_ID ,LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES(E2.EMPLOYEE_ID, E2.LAST_NAME, E2.EMAIL, E2.HIRE_DATE, E2.JOB_ID);

DELETE FROM EMPS WHERE EMPLOYEE_ID IS NULL;

--2ND
--서브쿼리 절로 다른 테이블을 가져오는 것이 아니라, 직접 값을 넣고자 할 때 사용할 수 있습니다.
MERGE INTO EMPS E1 --타겟테이블
USING DUAL 
ON (E1.EMPLOYEE_ID = 200) -- 이런경우 ON절은 고유한 키가 연결조건이 되어야 한다.
WHEN MATCHED THEN
    UPDATE SET E1.SALARY = 10000,
               E1.HIRE_DATE = SYSDATE,
               E1.COMMISSION_PCT = 0.1
WHEN NOT MATCHED THEN
    INSERT (EMPLOYEE_ID , LAST_NAME , EMAIL, HIRE_DATE,JOB_ID)
    VALUES ( 200, 'TEST' , 'TEST',SYSDATE , 'TEST');
    
    
--------------------------------------------
--CATS (CREATE TABLE AS SELECT ) - 테이블 복사(많이 사용되진 X)
CREATE TABLE EMPS2 AS (SELECT * FROM EMPS) ; --EMPS 데이터를 전부 복사해서 EMPS2를 생성
CREATE TABLE EMPS2 AS (SELECT * FROM EMPS WHERE 1 = 2) ; --EMPS 테이블 구조만 복사해서 생성
DROP TABLE EMPS2; --테이블 삭제 
SELECT * FROM EMPS2;

-------------------------------------------------------------------

--모든 문제는 변경한 후 select문으로 조회로 확인한 후 commit합니다
--문제 1.
--DEPTS테이블의 다음을 추가하세요
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS);
INSERT INTO DEPTS VALUES(280,'개발',NULL , 1800);
INSERT INTO DEPTS VALUES(290,'회계부',NULL , 1800);
INSERT INTO DEPTS VALUES(300,'재정',301,1800);
INSERT INTO DEPTS VALUES(310,'인사',302,1800);
INSERT INTO DEPTS VALUES(320,'영업',303,1700);        


--문제 2.
--DEPTS테이블의 데이터를 수정합니다
--1. department_name 이 IT Support 인 데이터의 department_name을 IT bank로 변경
UPDATE DEPTS SET DEPARTMENT_NAME = 'IT bank' WHERE DEPARTMENT_NAME = 'IT Support';
--2. department_id가 290인 데이터의 manager_id를 301로 변경
UPDATE DEPTS SET DEPARTMENT_ID = 301 WHERE DEPARTMENT_ID = 290;
--3. department_name이 IT Helpdesk인 데이터의 부서명을 IT Help로 , 매니저아이디를 303으로, 지역아이디를
--1800으로 변경하세요
UPDATE DEPTS SET DEPARTMENT_NAME = 'IT HELP' ,
                 MANAGER_ID = 303 ,     
                 LOCATION_ID = 1800
WHERE DEPARTMENT_NAME = 'IT Helpdesk';
--4. 이사, 부장, 과장, 대리 의 매니저아이디를 301로 한번에 변경하세요.
UPDATE DEPTS SET MANAGER_ID = 301 WHERE DEPARTMENT_ID IN(290,300,310,320);
SELECT * FROM DEPTS;

--문제 3.
--삭제의 조건은 항상 primary key로 합니다, 여기서 primary key는 department_id라고 가정합니다.
--1. 부서명 영업부를 삭제 하세요
DELETE FROM DEPTS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPTS WHERE DEPARTMENT_NAME ='영업');
--2. 부서명 NOC를 삭제하세요
SELECT * FROM DEPTS WHERE DEPARTMENT_NAME = 'NOC';
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 220;

--문제4
--1. Depts 사본테이블에서 department_id 가 200보다 큰 데이터를 삭제하세요.
DELETE FROM DEPTS WHERE DEPARTMENT_ID > 200;
--2. Depts 사본테이블의 manager_id가 null이 아닌 데이터의 manager_id를 전부 100으로 변경하세요.
UPDATE DEPTS SET MANAGER_ID = 100 WHERE MANAGER_ID IS NOT NULL ;
--3. Depts 테이블은 타겟 테이블 입니다.
--4. Departments테이블은 매번 수정이 일어나는 테이블이라고 가정하고 Depts와 비교하여
--일치하는 경우 Depts의 부서명, 매니저ID, 지역ID를 업데이트 하고
--새로유입된 데이터는 그대로 추가해주는 merge문을 작성하세요.

MERGE INTO DEPTS D
USING ( SELECT * FROM DEPARTMENTS) D1
ON (D.DEPARTMENT_ID = D1.DEPARTMENT_ID)
WHEN MATCHED THEN
   UPDATE SET  D.DEPARTMENT_NAME = D1.DEPARTMENT_NAME,
               D.MANAGER_ID = D1.MANAGER_ID,
               D.LOCATION_ID = D1.LOCATION_ID
WHEN NOT MATCHED THEN
    INSERT (DEPARTMENT_ID , DEPARTMENT_NAME , MANAGER_ID , LOCATION_ID)
    VALUES (D1.DEPARTMENT_ID ,D1.DEPARTMENT_NAME , D1.MANAGER_ID , D1.LOCATION_ID);
SELECT * FROM JOBS;

SELECT * FROM DEPTS;
--문제 5
--1. jobs_it 사본 테이블을 생성하세요 (조건은 min_salary가 6000보다 큰 데이터만 복사합니다)
CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY >6000);
--2. jobs_it 테이블에 다음 데이터를 추가하세요
INSERT INTO JOBS_IT (JOB_ID , JOB_TITLE , MIN_SALARY , MAX_SALARY) VALUES ('IT_DEV' ,'아이티개발팀' , 6000 , 20000);
INSERT INTO JOBS_IT (JOB_ID , JOB_TITLE , MIN_SALARY , MAX_SALARY) VALUES ('NET_DEV' ,'네트워크개발팀' , 5000 , 20000);
INSERT INTO JOBS_IT (JOB_ID , JOB_TITLE , MIN_SALARY , MAX_SALARY) VALUES ('SEC_DEV' ,'보안개발팀' , 6000 , 19000);
--3. jobs_it은 타겟 테이블 입니다
--4. jobs테이블은 매번 수정이 일어나는 테이블이라고 가정하고 jobs_it과 비교하여
--min_salary컬럼이 0보다 큰 경우 기존의 데이터는 min_salary, max_salary를 업데이트 하고 새로 유입된
--데이터는 그대로 추가해주는 merge문을 작성하세요
--JOB_ID JOB_TITLE MIN_SALARY MAX_SALARY
--IT_DEV 아이티개발팀 6000 20000
--NET_DEV 네트워크개발팀 5000 20000
--SEC_DEV 보안개발팀 6000 1900

MERGE INTO JOBS_IT JI
USING (SELECT * FROM JOBS WHERE MIN_SALARY > 0 ) J
ON (JI.JOB_ID = J.JOB_ID)
WHEN MATCHED THEN
    UPDATE SET JI.MIN_SALARY = J.MIN_SALARY,
               JI.MAX_SALARY = J.MAX_SALARY 
WHEN NOT MATCHED THEN
    INSERT (JOB_ID, JOB_TITLE , MIN_SALARY,MAX_SALARY)
    VALUES (J.JOB_ID , J.JOB_TITLE,J.MIN_SALARY,J.MAX_SALARY);
    
