--그룹함수 - 행에대한 기초통계 값
-- SUM,AVG,MAX,MIN,COUNT - 전부 NULL 이 아닌 데이터에 대해서 통계를 구합니다.
SELECT SUM(SALARY) ,TRUNC(AVG(SALARY),2) ,MAX(SALARY) ,MIN(SALARY),COUNT(SALARY) FROM EMPLOYEES;

--MAX , MIN은 문자열이나 날짜에도 적용이 됩니다.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE) FROM EMPLOYEES;
SELECT MIN(FIRST_NAME) , MAX(FIRST_NAME) FROM EMPLOYEES;

--COUNT() 두가지 사용방법
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES; -- NULL이 아닌 데이터 기준
SELECT COUNT(*) FROM EMPLOYEES; --전체행수(NULL포함)

--80인 부서사람들의 COMMISSION 통계값
SELECT MIN(COMMISSION_PCT), MAX(COMMISSION_PCT), SUM(COMMISSION_PCT) FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;

--주의할 점 : 그룹함수는 일반컬럼과 동시에 사용이 불가능
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES;

--그룹함수 뒤에 OVER() 를 붙이면 전체행 출력이 된다.
SELECT FIRST_NAME , AVG(SALARY) OVER(), MAX(SALARY) OVER() , COUNT(*) OVER() FROM EMPLOYEES;

---

--GROUP BY절 - 컬럼기준으로 그룹핑
SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID , SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY), COUNT(*)
FROM EMPLOYEES GROUP BY DEPARTMENT_ID; --그룹함수를 함께 사용할 수 있다.

--주의할 점 - GROUP BY 지정되지않은 컬럼은 SELECT절에 사용할 수 없음
SELECT DEPARTMENT_ID , FIRST_NAME
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--2개 이상의 그룹화(하위 그룹)
SELECT DEPARTMENT_ID,JOB_ID , SUM(SALARY),COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

-- COUNT(*) OVER() 을 사용하면 , 총 행의 수를 같이 출력할 수 있다
SELECT DEPARTMENT_ID , JOB_ID , COUNT(*),COUNT(*) OVER()
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID , JOB_ID
ORDER BY DEPARTMENT_ID;

--WHERE에는 그룹함수 조건을 사용할 수 없습니다. (단,일반조건은 가능)
SELECT DEPARTMENT_ID , SUM(SALARY) , (AVG(SALARY))
FROM EMPLOYEES
--WHERE SUM(SALARY) >=100000 - 그룹함수의 조건을 쓰는 구문은 HAVING이라고 따로 있다.
WHERE DEPARTMENT_ID >=10
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

--
--HAVING -그룹함수의 조건
--WHERE - 일반조건

SELECT DEPARTMENT_ID , SUM(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING SUM(SALARY) >= 100000 AND COUNT(*) >= 40;

SELECT DEPARTMENT_ID  JOB_ID , AVG(SALARY)
FROM EMPLOYEES
WHERE JOB_ID NOT LIKE 'SA%'
GROUP BY DEPARTMENT_ID , JOB_ID
HAVING AVG(SALARY) >= 5000;

--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과 , 급여합계를 평균기준 내림차순

SELECT DEPARTMENT_ID,
        AVG(SALARY) ,
    
        SUM(SALARY)
FROM EMPLOYEES 
WHERE HIRE_DATE LIKE '05%'
GROUP BY DEPARTMENT_ID 
HAVING DEPARTMENT_ID IS NOT NULL 
ORDER BY SUM(SALARY) DESC;

--시험에 많이 나옴
--ROLLUP - GROUP BY와 함께 사용되고, 상위그룹의 합계,평균을  구합니다.

SELECT DEPARTMENT_ID ,AVG(SALARY),SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID) --부서별 전체합계, 전체 평균
ORDER BY DEPARTMENT_ID;
--
SELECT DEPARTMENT_ID , JOB_ID, AVG(SALARY) , SUM(SALARY) 
FROM EMPLOYEES 
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID , JOB_ID; --부서 합계, 평균, 전체합계 , 전체평균


--CUBE - 롤업에 의해서 구해진 값 + 서브그룹 통계 추가됨
SELECT DEPARTMENT_ID , JOB_ID , AVG(SALARY), SUM(SALARY)
FROM EMPLOYEES
GROUP BY CUBE(DEPARTMENT_ID , JOB_ID)
ORDER BY AVG(SALARY) DESC;

--GROUPING함수 - 그룹절로 만들어진 경우는 0을 반환, 롤업OR큐브로 만들어진 행인 경우에는 1을 반환
SELECT DECODE(GROUPING(DEPARTMENT_ID),1,'총계',DEPARTMENT_ID),
        DECODE(GROUPING(JOB_ID),1,'소계',JOB_ID ),
        AVG(SALARY),
        GROUPING(DEPARTMENT_ID),
        GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY ROLLUP (DEPARTMENT_ID , JOB_ID)
ORDER BY DEPARTMENT_ID;
