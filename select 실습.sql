----������������ 1.
--��� ���̺��� JOB_ID�� ��� ���� ���ϼ���.
--��� ���̺��� JOB_ID�� ������ ����� ���ϼ���. ������ ��� ������ �������� �����ϼ���


SELECT * FROM EMPLOYEES ORDER BY HIRE_DATE;

SELECT JOB_ID ,
        COUNT(*) AS ����� ,
        AVG(SALARY) AS �޿���� 
FROM EMPLOYEES 
GROUP BY JOB_ID 
ORDER BY AVG(SALARY) DESC;

SELECT JOB_ID, AVG(SALARY) FROM EMPLOYEES GROUP BY CUBE(JOB_ID) ORDER BY(AVG(SALARY)) DESC;
--���� 2.
--��� ���̺��� �Ի� �⵵ �� ��� ���� ���ϼ���.
SELECT SUBSTR(HIRE_DATE, 1, 2) ||'�⵵' ,COUNT(*) FROM EMPLOYEES GROUP BY SUBSTR(HIRE_DATE,1,2) ORDER BY SUBSTR(HIRE_DATE,1,2);

SELECT TO_CHAR(HIRE_DATE , 'YY') AS �Ի�⵵, COUNT(*) AS �����
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE, 'YY');

--���� 3.
--�޿��� 1000 �̻��� ������� �μ��� ��� �޿��� ����ϼ���. �� �μ� ��� �޿��� 2000�̻��� �μ��� ���

SELECT DEPARTMENT_ID ,AVG(SALARY)
FROM EMPLOYEES 
WHERE SALARY>=1000 
GROUP BY(DEPARTMENT_ID)
HAVING AVG(SALARY) >= 2000
ORDER BY DEPARTMENT_ID;
--���� 4.
--��� ���̺��� commission_pct(Ŀ�̼�) �÷��� null�� �ƴ� �������
--department_id(�μ���) salary(����)�� ���, �հ�, count�� ���մϴ�.
--���� 1) ������ ����� Ŀ�̼��� �����Ų �����Դϴ�.
--���� 2) ����� �Ҽ� ��° �ڸ����� ����
SELECT DEPARTMENT_ID,
       TRUNC( AVG(SALARY+SALARY*COMMISSION_PCT),2),
        SUM(SALARY+SALARY*COMMISSION_PCT),
        COUNT(DEPARTMENT_ID) 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID;

--5
SELECT  DECODE(GROUPING(JOB_ID),1,'�հ�', JOB_ID) ,SUM(SALARY) 
FROM EMPLOYEES
GROUP BY ROLLUP(JOB_ID);

--6
SELECT  DECODE(GROUPING(DEPARTMENT_ID) ,1,'�հ�',DEPARTMENT_ID),
        DECODE(GROUPING(JOB_ID),1,'�Ұ�',JOB_ID ),
        COUNT(*) AS TOTAL,
        SUM(SALARY)
      
FROM EMPLOYEES
GROUP BY ROLLUP (DEPARTMENT_ID , JOB_ID)
ORDER BY SUM(SALARY);

