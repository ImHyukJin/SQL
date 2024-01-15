--��������

--������ �������� - SELECT�� ����� 1���� ��������
--���������� ������ ()�� �ݵ�� ���´�, �����ں��� �����ʿ� ��ġ��

--������ �޿����� ���� �޿��� �޴� ���
SELECT *FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy';

SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

--EMPLOYEE_ID�� 103���� ����� ������ ������ ���
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 103; -- IT_PROG

SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

--������ �� --���� �÷��� ��Ȯ�� �Ѱ����� �մϴ�
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

--������ �� - �������� ������ �����̶��, ������ �������� �������� �ۼ��� ���� �մϴ�.(ó���� ����� ����)
SELECT JOB_ID 
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');

------------------------
--������ �������� - �������� ���ϵǴ� ��������
--IN,ANY(SOME),ALL

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME = 'David';

-- 4800 ,6800 , 9500 �� 4800���� ū �����ʹ� �� ����(�ּڰ� ���� ū ������)
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 4800 ,6800 , 9500 �� 9500���� ���� �����ʹ� �� ����(�ִ� ���� ���� ������)
SELECT *
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 4800, 6800 , 9500 �� 9500���� ū �����Ͱ� �� ����(�ִ񰪺��� ū ������)
SELECT *
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 4800, 6800 , 9500 �� 4800���� ���� �����Ͱ� �� ����(�ּڰ����� ���� ������)
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- IN ������ �������� , ��Ȯ�� ��ġ�ϴ� �����Ͱ� �� ����
SELECT *
FROM EMPLOYEES
WHERE SALARY IN (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--STEVEN�� ������ �μ���ȣ�� ������ �����
SELECT DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME ='Steven');

-- STEVEN�� DAVID�� ������ JOB�� ������ ����� UNION ALL
SELECT FIRST_NAME || ' ' || LAST_NAME AS NAME
FROM EMPLOYEES
WHERE JOB_ID IN (SELECT JOB_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven' OR FIRST_NAME = 'David');


----------------------
-- ��Į�� ���� - SELECT���� ���������� ���� ����

--JOIN DEPARTMENT_NAME
SELECT E.FIRST_NAME,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

--��Į��
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS DEPARTMENT_NAME
FROM EMPLOYEES E
ORDER BY FIRST_NAME;

--��Į�������� �ѹ��� �ϳ��� �÷��� ������ �ɴϴ�. ���� ���� ������ �ö��� �������� ������ �� �ִ�.
--�μ����� ������ ����,�������� ����մϴ�
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID),
       (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID)
FROM EMPLOYEES E;

--��Į������ (������ ��ü����)
--��Į�������� ���κ��� �������
--1) �����Ͱ� ���� ��
--2) �÷�(�ε���) �� ������ �� �ִٸ� , ��Į�� ���� , �ε��� ������ �ȵǴ� ��� ������ ������


---------------------------------------------

--�ζ��� �� - FROM������ ������������ ���ϴ�.
SELECT *
FROM (SELECT * 
      FROM (SELECT *
            FROM EMPLOYEES));
            
--ROWNUM�� ��ȸ�� ������ ���� ��ȣ�� �ٱ� ������ , ORDER�� ��Ű�� ������ �ڹٲ�ϴ�.
SELECT FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;

--�ζ��� ��� �ذ�
SLECT ROWNUM,
      FIRST_NAME,
      SALARY
FROM(SELECT FIRST_NAME ,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC);





