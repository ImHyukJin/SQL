--제어문
--IF ~~ THEN
--ELSIF ~~ THEN
--ELSE ~~
--END IF;

SET SERVEROUTPUT ON;

DECLARE
    NUM NUMBER := TRUNC(DBMS_RANDOM.VALUE(1,11)); --1~11미만의 랜덤한 정수
    NUM2 NUMBER := 5;
BEGIN
    DBMS_OUTPUT.PUT_LINE(NUM);
    
    IF NUM>= NUM2 THEN
        DBMS_OUTPUT.PUT_LINE(NUM || '이 큰수 입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE(NUM2 || '이 큰 수 입니다');
    END IF;
END;

--ELSE IF ,CASE WHEN THEN
DECLARE
    RAN_NUM NUMBER := TRUNC(DBMS_RANDOM.VALUE(1,101)); --1~101미만 랜덤한 정수
BEGIN
/*
    IF RAN_NUM >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('A학점 입니다');
    ELSIF RAN_NUM >= 80 THEN   
        DBMS_OUTPUT.PUT_LINE('B학점 입니다');
    ELSIF RAN_NUM >= 70 THEN   
        DBMS_OUTPUT.PUT_LINE('C학점 입니다');
    ELSE   
        DBMS_OUTPUT.PUT_LINE('D학점 입니다');
     END IF;
*/
    CASE WHEN RAN_NUM>=90 THEN DBMS_OUTPUT.PUT_LINE('A학점 입니다');
         WHEN RAN_NUM>=80 THEN DBMS_OUTPUT.PUT_LINE('B학점 입니다');
         WHEN RAN_NUM>=70 THEN DBMS_OUTPUT.PUT_LINE('C학점 입니다');
         ELSE  DBMS_OUTPUT.PUT_LINE('D학점 입니다');
    END CASE;
END;

----------------------------------------------------
--반복문 WHILE ;

DECLARE 
    V_COUNT NUMBER := 1;
BEGIN
    
    WHILE V_COUNT <= 9
    LOOP
        DBMS_OUTPUT.PUT_LINE('3 X ' || V_COUNT || '=' || 3* V_COUNT);
        
        V_COUNT := V_COUNT +1;
    END LOOP;

END;

---------------------------------------------------
--FOR문
DECLARE
    DAN NUMBER := 3;
BEGIN
    FOR I IN 1..9 --1~9까지 값을 I에 담는다
    LOOP
        DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || I || ' = ' || DAN * I);
    END LOOP;
END;
--탈출문 EXIT WHEN 조건, CONTINUE WHEN 조건
DECLARE
BEGIN

    FOR I IN 1..10
    LOOP
        CONTINUE WHEN I = 5; --NUM이 5면 다음으로
        DBMS_OUTPUT.PUT_LINE(I);
        --EXIT WHEN I = 5; --NUM이 5면 탈출
    END LOOP;
    
END;

-------------------------------------------------------------

--커서 : 질의 수행결과가 여러행일 때 한 행씩 처리하는 방법
--반환되는 행이 여러행 이기 때문에 , 처리가 불가능(커서를 이용해서 처리)
DECLARE
    NM VARCHAR2(30);
    SALARY NUMBER;
BEGIN
    SELECT FIRST_NAME , SALARY
    INTO NM, SALARY
    FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG';
END;
--------------------------------------
DECLARE
    NM VARCHAR2(30);
    SALARY NUMBER;
    CURSOR X IS SELECT FIRST_NAME , SALARY FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'; --1. 커서 선언
BEGIN
    OPEN X; --2. 커서 선언
        DBMS_OUTPUT.PUT_LINE('=============커서시작===============');
    LOOP
        FETCH X INTO NM , SALARY; -- 4. 커서의 데이터를 변수에 저장
        EXIT WHEN X%NOTFOUND; -- 5.커서에 더이상 읽을 데이터가 없다면 TRUE
        DBMS_OUTPUT.PUT_LINE(NM);
        DBMS_OUTPUT.PUT_LINE(SALARY);
        
    END LOOP; 
        DBMS_OUTPUT.PUT_LINE('=============커서종료================');
        DBMS_OUTPUT.PUT_LINE('결과레코드 수 : ' || X%ROWCOUNT);
    CLOSE X;--3. 커서 종료
END;

--1. 모든 구구단을 출력하는 익명블록을 만드세요.
DECLARE
BEGIN
    FOR J IN 1..9
        LOOP
             FOR I IN 1..9 --1~9까지 값을 I에 담는다
                LOOP
                   DBMS_OUTPUT.PUT_LINE(J || ' X ' || I || ' = ' || J * I);
             END LOOP;
        END LOOP;
END;
--2. 첫번째 값은 rownum을 이용하면 됩니다.
--조건) 10 ~120사이의 10단위 랜덤한 번호를 이용해서 랜덤 department_id의 첫번째 행만 select합니다
DECLARE
    NUM NUMBER := TRUNC(DBMS_RANDOM.VALUE(1,13)*10);
BEGIN
    SELECT DEPARTMENT_ID

    FROM EMPLOYEES WHERE DEPARTMENT_ID = NUM;
END;

SELECT
    CASE
    WHEN E.SALARY >= 9000 THEN '높음'
    WHEN E.SALARY >= 5000 THEN '중간'
    ELSE '낮음'
    END 
FROM(
    SELECT SALARY
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = (
        SELECT DEPARTMENT_ID
        FROM (
            SELECT department_id
            FROM EMPLOYEES
            WHERE department_id BETWEEN 10 AND 120
            ORDER BY TRUNC(DBMS_RANDOM.VALUE(1,13)*10)
    )
    WHERE ROWNUM = 1
    ) 
    AND ROWNUM = 1
 )E;

--조건2) 뽑은 사람의 SALARY가 9000이상이면 높음,5000이상이면 중간 , 나머지는 낮음으로 출력.

--3. COURSE 테이블에 INSERT를 100번 실행하는 익명블록을 처리하세요.
--조건 ) NUM은 COURSE SEQ를 이용하세요.
SELECT * FROM COURSE;
drop table COURSE;
DECLARE
 COUSRE_ID COURSE.ID%TYPE;
BEGIN 
    FOR I IN 7..106
    LOOP 
    INSERT INTO COURSE (NUM , COURSE.ID)
    VALUES (COURSE_SEQ.NEXTVAL , COURSE_ID);
    END LOOP;
END;

DECLARE 
    
BEGIN

END;

CREATE TABLE COURSE(
    NUM  NUMBER(10) NOT NULL,
    SUBJECT VARCHAR2(20),
    CONTENT VARCHAR2(20),
    ID NUMBER(10)
);

CREATE SEQUENCE COURSE_SEQ NOCACHE;


DECLARE
BEGIN
  FOR I IN 1..100 
  LOOP

    INSERT INTO COURSE
    VALUES (COURSE_SEQ.NEXTVAL, 'SAF','ASDF',I,I);
  END LOOP;
  
  COMMIT;
END;
--4 부서별 급여합을 출력하는 커서구문을 작성

--5 사원테이블의 연도별 급여합을 구하여 EMP_SAL에 순차적으로 INSERT하는 커서구문을 작성