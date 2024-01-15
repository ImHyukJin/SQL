--서브쿼리

--단일행 서브쿼리 - SELECT한 결과가 1행인 서브쿼리
--서브쿼리의 문법은 ()로 반드시 묶는다, 연산자보다 오른쪽에 위치함

--낸시의 급여보다 높은 급여를 받는 사람
SELECT *FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy';

SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

--EMPLOYEE_ID가 103번인 사람과 동일한 직군인 사람
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 103; -- IT_PROG

SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

--주의할 점 --비교할 컬럼은 정확히 한개여야 합니다
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

--주의할 점 - 여러행이 나오는 구문이라면, 다중행 서브쿼리 구문으로 작성이 들어가야 합니다.(처리할 방법이 있음)
SELECT JOB_ID 
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');

------------------------
--다중행 서브쿼리 - 여러행이 리턴되는 서브쿼리
--IN,ANY(SOME),ALL

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME = 'David';

-- 4800 ,6800 , 9500 중 4800보다 큰 데이터는 다 나옴(최솟값 보다 큰 데이터)
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 4800 ,6800 , 9500 중 9500보다 작은 데이터는 다 나옴(최댓값 보다 작은 데이터)
SELECT *
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 4800, 6800 , 9500 중 9500보다 큰 데이터가 다 나옴(최댓값보다 큰 데이터)
SELECT *
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 4800, 6800 , 9500 중 4800보다 작은 데이터가 다 나옴(최솟값보다 작은 데이터)
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- IN 다중행 데이터중 , 정확히 일치하는 데이터가 다 나옴
SELECT *
FROM EMPLOYEES
WHERE SALARY IN (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--STEVEN과 동일한 부서번호를 가지는 사람들
SELECT DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME ='Steven');

-- STEVEN과 DAVID와 동일한 JOB을 가지는 사람들 UNION ALL
SELECT FIRST_NAME || ' ' || LAST_NAME AS NAME
FROM EMPLOYEES
WHERE JOB_ID IN (SELECT JOB_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven' OR FIRST_NAME = 'David');


----------------------
-- 스칼라 쿼리 - SELECT문에 서브쿼리가 들어가는 문장

--JOIN DEPARTMENT_NAME
SELECT E.FIRST_NAME,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

--스칼라
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS DEPARTMENT_NAME
FROM EMPLOYEES E
ORDER BY FIRST_NAME;

--스칼라쿼리는 한번에 하나의 컬럼을 가지고 옵니다. 많은 열을 가지고 올때는 가독성이 떨어질 수 있다.
--부서명을 가지고 오고,직무명을 출력합니다
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID),
       (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID)
FROM EMPLOYEES E;

--스칼라쿼리 (조인을 대체가능)
--스칼라쿼리가 조인보다 느린경우
--1) 데이터가 많을 때
--2) 컬럼(인덱스) 를 참조할 수 있다면 , 스칼라가 유리 , 인덱스 참조가 안되는 경우 조인이 유리함


---------------------------------------------

--인라인 뷰 - FROM하위에 서브쿼리절이 들어갑니다.
SELECT *
FROM (SELECT * 
      FROM (SELECT *
            FROM EMPLOYEES));
            
--ROWNUM은 조회된 순서에 대해 번호가 붙기 때문에 , ORDER를 시키면 순서가 뒤바뀝니다.
SELECT FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;

--인라인 뷰로 해결
SLECT ROWNUM,
      FIRST_NAME,
      SALARY
FROM(SELECT FIRST_NAME ,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC);





