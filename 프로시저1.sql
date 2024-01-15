--1. ���ν����� GUGUPROC
--- ������ �� �Է¹޾� �ش� �ܼ��� ����ϴ� procedure�� �����ϰ� �����ϼ���
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
--2. ���ν����� EMP_YEAR_PROC
--- EMPLOYEE_ID�� �޾Ƽ� EMPLOYEES�� �����ϸ�, "�ټӳ���� ���" �ϰ�, ���ٸ� "EMPLOYEE_ID�� �����ϴ�" �� ����ϴ� ���ν���
--- ����ó���� �ۼ����ּ���.
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

    DBMS_OUTPUT.PUT_LINE('�ټ� ���: ' || v_years);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID ' || p_employee_id || '�� �����ϴ�.');
END;

EXEC EMP_YEAR_PROC(101);
--3. ���ν����� DEPTS_PROC
--- �μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
--DEPTS���̺� ���� flag�� i�� INSERT, u�� UPDATE, d�� DELETE �ϴ� ���ν����� �����մϴ�.
--- �׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
--- ����ó���� �ۼ����ּ���.
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
        RAISE_APPLICATION_ERROR(-20001, '��ȿ���� ���� �۾� flag�Դϴ�.');
    END IF;

    COMMIT;
EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('���� �߻�: ' || SQLERRM);
END;
--4. ���ν����� EMP_AGE_PROC
--- employee_id�� �Է¹޾� employees�� �����ϸ�, �ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���.
--- ����ó���� �ۼ����ּ���.
--
CREATE OR REPLACE PROCEDURE EMP_AGE_PROC (
    EMP_EMPLOYEE_ID EMPLOYEES.EMPLOYEE.ID%TYPE);
    
--5. ���ν����� - EMP_MERGE_PROC
--- employees ���̺��� ���� ���̺� emps�� �����մϴ�.
--- employee_id, last_name, email, hire_date, job_id�� �Է¹޾� �����ϸ� �̸�, �̸���, �Ի���, ������ update, 
--���ٸ� insert�ϴ� merge���� �ۼ��ϼ���
--- ��Ʈ (MERGE INTO ���̺� USING ���� WHEN MATCHED THEN ������Ʈ WHEN NOT MATCHED THEN �μ�Ʈ )
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
        DBMS_OUTPUT.PUT_LINE('���� �߻�: ' || SQLERRM);
END;

EXEC EMP_MERGE_PROC(101,'sted','dqww','2012/12/12','IT_PROG');

SELECT * FROM EMPS;


--6. ���ν����� - SALES_PROC
--- sales���̺��� ������ �Ǹų����̴�.
--- day_of_sales���̺��� �Ǹų��� ������ ���� ������ �Ѹ����� ����ϴ� ���̺��̴�.
--- ������ sales�� ���ó�¥ �Ǹų����� �����Ͽ� day_of_sales�� �����ϴ� ���ν����� �����غ�����.
--����) day_of_sales�� ���������� �̹� �����ϸ� ������Ʈ ó��
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
        DBMS_OUTPUT.PUT_LINE('���� �߻�: ' || SQLERRM);
END;
