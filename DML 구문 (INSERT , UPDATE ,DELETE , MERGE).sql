--INSERT�� 2���� ����

--���̺� ������ ������ Ȯ���ϴ� ���
DESC DEPARTMENTS;

SELECT * FROM DEPARTMENTS;
--1ST (�÷��� ��Ȯ�ϰ� ��ġ��Ű�� ���� �÷��� ������ ����)
INSERT INTO DEPARTMENTS VALUES(280, '������', NULL, 1700);

--DML���� Ʈ������� �׻� ����˴ϴ�
ROLLBACK;

--2ND (�÷��� ��Ī�ؼ� �ִ� ���)
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID) VALUES(280, '������', 1700);

--�־��
INSERT INTO DEPARTMENTS VALUES(290, '�����̳�', NULL, 1700);
INSERT INTO DEPARTMENTS VALUES(300, 'DB������', NULL, 1800);
INSERT INTO DEPARTMENTS VALUES(310, '�����ͺм���', NULL, 1800);
INSERT INTO DEPARTMENTS VALUES(320, '�ۺ���', NULL, 1800);
INSERT INTO DEPARTMENTS VALUES(330, '����������', NULL, 1800);

---
--INSERT������ ���������� ���˴ϴ�.
--�ǽ��� ���� ��¥���̺� ����
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2); --������ �����ϴ� ���̺����( ������X )

SELECT * FROM EMPS;
DESC EMPS;
--1ST
--��� �÷��� �������� ���� ������
INSERT INTO EMPS(SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN');
--Ư�� �÷��� �������� ���� ������
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
-- 114�� �޿��� 10% �λ�
UPDATE EMPS SET SALARY = SALARY * 1.1 WHERE EMPLOYEE_ID = 114;

-- WHERE�� ���� ������ �����Ű��, ��ü ���̺� ����Ǳ� ������ �׻� WHERE���� �ٿ��� �մϴ�.
-- �׷��� �׻�, SELECT������ ������Ʈ�� ���� Ȯ���ϰ�, �����ϴ� ����
UPDATE EMPS SET SALARY = 0;
ROLLBACK;

-- ������ ������Ʈ
UPDATE EMPS SET SALARY = SALARY * 1.1
                ,COMMISSION_PCT = 0.5
                ,MANAGER_ID = 110
WHERE EMPLOYEE_ID = 114;

--UPDATE���� ����������
--1ST
--�����÷��� �ѹ��� ���������� ������Ʈ �ϴ� ����
SELECT * FROM EMPS;

UPDATE EMPS 
SET (MANAGER_ID, JOB_ID, DEPARTMENT_ID)
 = (SELECT MANAGER_ID, JOB_ID, DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201)
WHERE EMPLOYEE_ID = 114;
--�� �÷��� ���������� ������Ʈ �ϴ� ����
UPDATE EMPS
SET MANAGER_ID = (SELECT MANAGER_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201),
    JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201)
WHERE EMPLOYEE_ID = 114;
--WHERE������ ������ �˴ϴ�.
UPDATE EMPS
SET SALARY = 0
WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');

------------------------------------------
--DELETE��
--�����ϱ� ���� ��, SELECT������ ����Ű���带 Ȯ���ϴ� ������ ������ (�� PK������ �����ϼ���)
SELECT * FROM EMPS WHERE EMPLOYEE_ID = 114;

DELETE FROM EMPS WHERE EMPLOYEE_ID = 114;
DELETE FROM EMPS WHERE JOB_ID LIKE '%MAN';
--DELETE����������
DELETE FROM EMPS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPS WHERE EMPLOYEE_ID = 145); --80�� �μ�

----------------------------------------------------------------------------------
--DELETE���� �ݵ�� ���� �������°��� �ƴմϴ�.
--���̺��� �������� ������ ������, �������Ἲ���࿡ ����Ǵ� ���, �������� �ʽ��ϴ�.
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
 
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 20; --20�� �μ��� EMPLOTEE���� �����ǰ� �ֱ� ������ �������� �ʽ��ϴ�.


---------------------------------------------
--MERGE���� : �����Ͱ� ������ UPDATE, ������ INSERT ������ �����ϴ� , ���ձ���
UPDATE EMPS SET SALARY = 0;
DELETE FROM EMPS WHERE JOB_ID = 'SA_MAN';
SELECT * FROM EMPS;

--1ST
MERGE INTO EMPS E1 -- Ÿ�����̺�
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN') E2 --������ ��������
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID) -- ���� ����
WHEN MATCHED THEN -- ��ġ�� �� ������Ʈ
     UPDATE SET E1.SALARY = E2.SALARY,
                E1.COMMISSION_PCT = E2.COMMISSION_PCT
WHEN NOT MATCHED THEN -- ��ġ���� ���� �� �μ�Ʈ
    INSERT (EMPLOYEE_ID ,LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES(E2.EMPLOYEE_ID, E2.LAST_NAME, E2.EMAIL, E2.HIRE_DATE, E2.JOB_ID);

DELETE FROM EMPS WHERE EMPLOYEE_ID IS NULL;

--2ND
--�������� ���� �ٸ� ���̺��� �������� ���� �ƴ϶�, ���� ���� �ְ��� �� �� ����� �� �ֽ��ϴ�.
MERGE INTO EMPS E1 --Ÿ�����̺�
USING DUAL 
ON (E1.EMPLOYEE_ID = 200) -- �̷���� ON���� ������ Ű�� ���������� �Ǿ�� �Ѵ�.
WHEN MATCHED THEN
    UPDATE SET E1.SALARY = 10000,
               E1.HIRE_DATE = SYSDATE,
               E1.COMMISSION_PCT = 0.1
WHEN NOT MATCHED THEN
    INSERT (EMPLOYEE_ID , LAST_NAME , EMAIL, HIRE_DATE,JOB_ID)
    VALUES ( 200, 'TEST' , 'TEST',SYSDATE , 'TEST');
    
    
--------------------------------------------
--CATS (CREATE TABLE AS SELECT ) - ���̺� ����(���� ������ X)
CREATE TABLE EMPS2 AS (SELECT * FROM EMPS) ; --EMPS �����͸� ���� �����ؼ� EMPS2�� ����
CREATE TABLE EMPS2 AS (SELECT * FROM EMPS WHERE 1 = 2) ; --EMPS ���̺� ������ �����ؼ� ����
DROP TABLE EMPS2; --���̺� ���� 
SELECT * FROM EMPS2;

-------------------------------------------------------------------

--��� ������ ������ �� select������ ��ȸ�� Ȯ���� �� commit�մϴ�
--���� 1.
--DEPTS���̺��� ������ �߰��ϼ���
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS);
INSERT INTO DEPTS VALUES(280,'����',NULL , 1800);
INSERT INTO DEPTS VALUES(290,'ȸ���',NULL , 1800);
INSERT INTO DEPTS VALUES(300,'����',301,1800);
INSERT INTO DEPTS VALUES(310,'�λ�',302,1800);
INSERT INTO DEPTS VALUES(320,'����',303,1700);        


--���� 2.
--DEPTS���̺��� �����͸� �����մϴ�
--1. department_name �� IT Support �� �������� department_name�� IT bank�� ����
UPDATE DEPTS SET DEPARTMENT_NAME = 'IT bank' WHERE DEPARTMENT_NAME = 'IT Support';
--2. department_id�� 290�� �������� manager_id�� 301�� ����
UPDATE DEPTS SET DEPARTMENT_ID = 301 WHERE DEPARTMENT_ID = 290;
--3. department_name�� IT Helpdesk�� �������� �μ����� IT Help�� , �Ŵ������̵� 303����, �������̵�
--1800���� �����ϼ���
UPDATE DEPTS SET DEPARTMENT_NAME = 'IT HELP' ,
                 MANAGER_ID = 303 ,     
                 LOCATION_ID = 1800
WHERE DEPARTMENT_NAME = 'IT Helpdesk';
--4. �̻�, ����, ����, �븮 �� �Ŵ������̵� 301�� �ѹ��� �����ϼ���.
UPDATE DEPTS SET MANAGER_ID = 301 WHERE DEPARTMENT_ID IN(290,300,310,320);
SELECT * FROM DEPTS;

--���� 3.
--������ ������ �׻� primary key�� �մϴ�, ���⼭ primary key�� department_id��� �����մϴ�.
--1. �μ��� �����θ� ���� �ϼ���
DELETE FROM DEPTS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPTS WHERE DEPARTMENT_NAME ='����');
--2. �μ��� NOC�� �����ϼ���
SELECT * FROM DEPTS WHERE DEPARTMENT_NAME = 'NOC';
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 220;

--����4
--1. Depts �纻���̺��� department_id �� 200���� ū �����͸� �����ϼ���.
DELETE FROM DEPTS WHERE DEPARTMENT_ID > 200;
--2. Depts �纻���̺��� manager_id�� null�� �ƴ� �������� manager_id�� ���� 100���� �����ϼ���.
UPDATE DEPTS SET MANAGER_ID = 100 WHERE MANAGER_ID IS NOT NULL ;
--3. Depts ���̺��� Ÿ�� ���̺� �Դϴ�.
--4. Departments���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� Depts�� ���Ͽ�
--��ġ�ϴ� ��� Depts�� �μ���, �Ŵ���ID, ����ID�� ������Ʈ �ϰ�
--�������Ե� �����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���.

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
--���� 5
--1. jobs_it �纻 ���̺��� �����ϼ��� (������ min_salary�� 6000���� ū �����͸� �����մϴ�)
CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY >6000);
--2. jobs_it ���̺� ���� �����͸� �߰��ϼ���
INSERT INTO JOBS_IT (JOB_ID , JOB_TITLE , MIN_SALARY , MAX_SALARY) VALUES ('IT_DEV' ,'����Ƽ������' , 6000 , 20000);
INSERT INTO JOBS_IT (JOB_ID , JOB_TITLE , MIN_SALARY , MAX_SALARY) VALUES ('NET_DEV' ,'��Ʈ��ũ������' , 5000 , 20000);
INSERT INTO JOBS_IT (JOB_ID , JOB_TITLE , MIN_SALARY , MAX_SALARY) VALUES ('SEC_DEV' ,'���Ȱ�����' , 6000 , 19000);
--3. jobs_it�� Ÿ�� ���̺� �Դϴ�
--4. jobs���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� jobs_it�� ���Ͽ�
--min_salary�÷��� 0���� ū ��� ������ �����ʹ� min_salary, max_salary�� ������Ʈ �ϰ� ���� ���Ե�
--�����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���
--JOB_ID JOB_TITLE MIN_SALARY MAX_SALARY
--IT_DEV ����Ƽ������ 6000 20000
--NET_DEV ��Ʈ��ũ������ 5000 20000
--SEC_DEV ���Ȱ����� 6000 1900

MERGE INTO JOBS_IT JI
USING (SELECT * FROM JOBS WHERE MIN_SALARY > 0 ) J
ON (JI.JOB_ID = J.JOB_ID)
WHEN MATCHED THEN
    UPDATE SET JI.MIN_SALARY = J.MIN_SALARY,
               JI.MAX_SALARY = J.MAX_SALARY 
WHEN NOT MATCHED THEN
    INSERT (JOB_ID, JOB_TITLE , MIN_SALARY,MAX_SALARY)
    VALUES (J.JOB_ID , J.JOB_TITLE,J.MIN_SALARY,J.MAX_SALARY);
    
