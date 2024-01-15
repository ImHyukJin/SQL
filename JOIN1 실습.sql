--���� 1.
---EMPLOYEES ���̺��, DEPARTMENTS ���̺��� DEPARTMENT_ID�� ����Ǿ� �ֽ��ϴ�.
---EMPLOYEES, DEPARTMENTS ���̺��� ������� �̿��ؼ�
--���� INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER ���� �ϼ���. (�޶����� ���� ���� Ȯ��)
SELECT * FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID =D.DEPARTMENT_ID;
SELECT * FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID =D.DEPARTMENT_ID;
SELECT * FROM EMPLOYEES E RIGHT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID =D.DEPARTMENT_ID;
SELECT * FROM EMPLOYEES E FULL JOIN DEPARTMENTS D ON E.DEPARTMENT_ID =D.DEPARTMENT_ID;
--���� 2.
---EMPLOYEES, DEPARTMENTS ���̺��� INNER JOIN�ϼ���
--����)employee_id�� 200�� ����� �̸�, department_id�� ����ϼ���
--����)�̸� �÷��� first_name�� last_name�� ���ļ� ����մϴ�
SELECT FIRST_NAME || ' ' || LAST_NAME AS NAME, 
       D.DEPARTMENT_ID 
FROM EMPLOYEES E 
JOIN DEPARTMENTS D 
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE EMPLOYEE_ID = 200 ;
--���� 3.
---EMPLOYEES, JOBS���̺��� INNER JOIN�ϼ���
--����) ��� ����� �̸��� �������̵�, ���� Ÿ��Ʋ�� ����ϰ�, �̸� �������� �������� ����
--HINT) � �÷����� ���� ����� �ִ��� Ȯ��
SELECT * FROM JOBS;
SELECT FIRST_NAME || ' ' || LAST_NAME AS NAME , E.JOB_ID , JOB_TITLE 
FROM EMPLOYEES E
JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
ORDER BY NAME ASC;
--���� 4.
----JOBS���̺�� JOB_HISTORY���̺��� LEFT_OUTER JOIN �ϼ���.
SELECT * FROM JOB_HISTORY ;
SELECT * 
FROM JOBS J
LEFT JOIN JOB_HISTORY H
ON J.JOB_ID = H.JOB_ID ;
--���� 5.
----Steven King�� �μ����� ����ϼ���.
SELECT DEPARTMENT_ID ,FIRST_NAME || ' ' ||LAST_NAME
FROM EMPLOYEES
WHERE FIRST_NAME ='Steven' AND LAST_NAME ='King';
--���� 6.
----EMPLOYEES ���̺�� DEPARTMENTS ���̺��� Cartesian Product(Cross join)ó���ϼ���
SELECT * 
FROM EMPLOYEES E
CROSS JOIN DEPARTMENTS D;
--���� 7.
----EMPLOYEES ���̺�� DEPARTMENTS ���̺��� �μ���ȣ�� �����ϰ� SA_MAN ������� �����ȣ, �̸�, 
--�޿�, �μ���, �ٹ����� ����ϼ���. (Alias�� ���)
SELECT * FROM LOCATIONS;
SELECT E.EMPLOYEE_ID , E.FIRST_NAME || ' ' || E.LAST_NAME AS NAME , E.SALARY , D.DEPARTMENT_NAME ,l.street_address
FROM EMPLOYEES E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L 
ON D.LOCATION_ID = L.LOCATION_ID
WHERE JOB_ID = 'SA_MAN';
--���� 8.
---- employees, jobs ���̺��� ���� �����ϰ� job_title�� 'Stock Manager', 'Stock Clerk'�� ���� ������
--����ϼ���.
SELECT * FROM JOBS;
SELECT * 
FROM EMPLOYEES E
JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
JOIN JOB_HISTORY H
ON J.JOB_ID = H.JOB_ID
WHERE JOB_TITLE = 'Stock Manager' or JOB_TITLE = 'Stock Clerk';
--���� 9.
---- departments ���̺��� ������ ���� �μ��� ã�� ����ϼ���. LEFT OUTER JOIN ���
SELECT * FROM DEPARTMENTS D;
SELECT DEPARTMENT_NAME 
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E
ON d.department_ID = E.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID IS NULL;
--���� 10. 
---join�� �̿��ؼ� ����� �̸��� �� ����� �Ŵ��� �̸��� ����ϼ���
--��Ʈ) EMPLOYEES ���̺�� EMPLOYEES ���̺��� �����ϼ���.
SELECT * FROM EMPLOYEES;
SELECT E1.FIRST_NAME ||' '||E1.LAST_NAME AS ��� ,E2.FIRST_NAME || ' ' || E2.LAST_NAME AS �Ŵ���
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID;
--���� 11. 
----6. EMPLOYEES ���̺��� left join�Ͽ� ������(�Ŵ���)��, �Ŵ����� �̸�, �Ŵ����� �޿� ���� ����ϼ���
----�Ŵ��� ���̵� ���� ����� �����ϰ� �޿��� �������� ����ϼ���
SELECT E1.FIRST_NAME || ' ' ||E1.LAST_NAME AS ��� , E2.FIRST_NAME || ' ' || E2.LAST_NAME AS �Ŵ��� , E2.SALARY AS "�Ŵ��� �޿�"
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID
WHERE E1.MANAGER_ID IS NOT NULL
ORDER BY E2.SALARY DESC;
--���� 12
--���������̽��� ���޵�(�����)�� ���ϼ���.
--STEVEN > GERALD > WILLIAM
SELECT FIRST_NAME FROM EMPLOYEES;
SELECT E1.FIRST_NAME ||'>'|| E2.FIRST_NAME ||'>'|| E3.FIRST_NAME 
FROM EMPLOYEES E1
JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID
JOIN EMPLOYEES E3
ON E2.MANAGER_ID = E3.EMPLOYEE_ID
WHERE E1.FIRST_NAME IN ('William') AND E1.LAST_NAME IN('Smith');