--1. 프로시저명 GUGUPROC
--- 구구단 을 입력받아 해당 단수를 출력하는 procedure을 생성하고 실행하세요
--
CREATE OR REPLACE PROCEDURE GUGUPROC (
    p_number IN NUMBER
)
IS
    v_result NUMBER;
BEGIN
    FOR i IN 1..9 LOOP
        v_result := p_number * i;
        DBMS_OUTPUT.PUT_LINE(p_number || ' * ' || i || ' = ' || v_result);
    END LOOP;
END;
EXEC GUGUPROC(7);
--2. 프로시저명 EMP_YEAR_PROC
--- EMPLOYEE_ID를 받아서 EMPLOYEES에 존재하면, "근속년수를 출력" 하고, 없다면 "EMPLOYEE_ID는 없습니다" 를 출력하는 프로시저
--- 예외처리도 작성해주세요.
--
CREATE OR REPLACE PROCEDURE EMP_YEAR_PROC (
    p_employee_id IN employees.employee_id%TYPE
)
IS
    v_hire_date employees.hire_date%TYPE;
    v_years NUMBER;
BEGIN
    SELECT hire_date INTO v_hire_date
    FROM employees
    WHERE employee_id = p_employee_id;
    
    v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);

    DBMS_OUTPUT.PUT_LINE('근속 년수: ' || v_years);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID ' || p_employee_id || '는 없습니다.');
END;

EXEC EMP_YEAR_PROC(101);
--3. 프로시저명 DEPTS_PROC
--- 부서번호, 부서명, 작업 flag(I: insert, U:update, D:delete)을 매개변수로 받아 
--DEPTS테이블에 각각 flag가 i면 INSERT, u면 UPDATE, d면 DELETE 하는 프로시저를 생성합니다.
--- 그리고 정상종료라면 commit, 예외라면 롤백 처리하도록 처리하세요.
--- 예외처리도 작성해주세요.
--
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS WHERE 1= 1);

SELECT * FROM DEPTS;

CREATE OR REPLACE PROCEDURE DEPTS_PROC (
    p_department_id IN DEPTS.department_id%TYPE,
    p_department_name IN DEPTS.department_name%TYPE,
    p_action_flag IN VARCHAR2
)
IS
BEGIN
    IF p_action_flag = 'I' THEN -- INSERT
        INSERT INTO DEPTS (department_id, department_name)
        VALUES (p_department_id, p_department_name);
    ELSIF p_action_flag = 'U' THEN -- UPDATE
        UPDATE DEPTS
        SET department_name = p_department_name
        WHERE department_id = p_department_id;
    ELSIF p_action_flag = 'D' THEN -- DELETE
        DELETE FROM DEPTS
        WHERE department_id = p_department_id;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, '유효하지 않은 작업 flag입니다.');
    END IF;

    COMMIT;
EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('예외 발생: ' || SQLERRM);
END;
--4. 프로시저명 EMP_AGE_PROC
--- employee_id를 입력받아 employees에 존재하면, 근속년수를 out하는 프로시저를 작성하세요.
--- 예외처리도 작성해주세요.
--
CREATE OR REPLACE PROCEDURE EMP_AGE_PROC (
    EMP_EMPLOYEE_ID EMPLOYEES.EMPLOYEE.ID%TYPE);
    
--5. 프로시저명 - EMP_MERGE_PROC
--- employees 테이블의 복사 테이블 emps를 생성합니다.
--- employee_id, last_name, email, hire_date, job_id를 입력받아 존재하면 이름, 이메일, 입사일, 직업을 update, 
--없다면 insert하는 merge문을 작성하세요
--- 힌트 (MERGE INTO 테이블 USING 조건 WHEN MATCHED THEN 업데이트 WHEN NOT MATCHED THEN 인서트 )
--
DROP TABLE EMPS;
CREATE TABLE EMPS AS (SELECT *FROM EMPLOYEES WHERE 1=1);
SELECT * FROM EMPS;

CREATE OR REPLACE PROCEDURE EMP_MERGE_PROC (
    p_employee_id IN employees.employee_id%TYPE,
    p_last_name IN employees.last_name%TYPE,
    p_email IN employees.email%TYPE,
    p_hire_date IN employees.hire_date%TYPE,
    p_job_id IN employees.job_id%TYPE
)
IS
BEGIN
    MERGE INTO employees e
    USING (
        SELECT 
            p_employee_id AS employee_id,
            p_last_name AS last_name,
            p_email AS email,
            p_hire_date AS hire_date,
            p_job_id AS job_id
        FROM dual
    ) emps ON (e.employee_id = emps.employee_id)
    WHEN MATCHED THEN
        UPDATE SET
            e.last_name = emps.last_name,
            e.email = emps.email,
            e.hire_date = emps.hire_date,
            e.job_id = emps.job_id
    WHEN NOT MATCHED THEN
        INSERT (employee_id, last_name, email, hire_date, job_id)
        VALUES (emps.employee_id, emps.last_name, emps.email, emps.hire_date, emps.job_id);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('예외 발생: ' || SQLERRM);
END;

EXEC EMP_MERGE_PROC(101,'sted','dqww','2012/12/12','IT_PROG');

SELECT * FROM EMPS;


--6. 프로시저명 - SALES_PROC
--- sales테이블은 오늘의 판매내역이다.
--- day_of_sales테이블은 판매내역 마감시 오늘 일자의 총매출을 기록하는 테이블이다.
--- 마감시 sales의 오늘날짜 판매내역을 집계하여 day_of_sales에 집계하는 프로시저를 생성해보세요.
--조건) day_of_sales의 마감내역이 이미 존재하면 업데이트 처리
CREATE TABLE SALES AS( SELECT * FROM 
SELECT * FROM SALES;
CREATE OR REPLACE PROCEDURE SALES_PROC 
IS
BEGIN
    MERGE INTO DAY_OF_SALESNMNJJJJJJJJJJJJJJJNBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBNNBBNN
    USING (
        SELECT 
            SALE
        FROM SALES
        WHERE TRUNC(SALE_DATE) = TRUNC(SYSDATE)
        GROUP BY TRUNC(SALE_DATE)
    ) sales ON (DOS_SALE_DATE = SALES.SALES_DATE)
    WHEN MATCHED THEN
        UPDATE SET dos.total_sales = sales.total_sales
    WHEN NOT MATCHED THEN
        INSERT (sale_date, total_sales)
        VALUES (sales.sale_date, sales.total_sales);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('예외 발생: ' || SQLERRM);
END;
