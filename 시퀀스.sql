--������ (���������� �����ϴ� ��)*
SELECT * FROM USER_SEQUENCES;

--����
CREATE SEQUENCE DEPTS_SEQ; --�⺻������ �����Ǹ鼭 �������� �����˴ϴ� 

DROP SEQUENCE DEPTS_SEQ; --����

CREATE SEQUENCE DEPTS_SEQ
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 10 
    NOCYCLE --�������� MAX�� �������� �� ����X
    NOCACHE;  -- ĳ�ÿ� �������� ���� �ʰڴ�

--�������� �Ϲ������� PK�� �ڵ������ϴ� ������ ������ �˴ϴ�.
CREATE TABLE DEPTS(
    DEPT_NO NUMBER(2) CONSTRAINT DEPTS_NO_PK PRIMARY KEY,
    DEPT_NAME VARCHAR2(30),
    DEPT_DATE DATE
    
);
DROP SEQUENCE DEPTS_SEQ;
SELECT * FROM DEPTS;
--�������� ����� 2�� *
SELECT DEPTS_SEQ.CURRVAL FROM DUAL ; -- NEWTVAL�� �ѹ� ������ �ǰ� ���� Ȯ���� �����ϴ�
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL ; --�ѹ� NEXTVAL�� �Ͼ�� , ������ �Ұ����ϴ�

INSERT INTO DEPTS VALUES(DEPTS_SEQ.NEXTVAL , 'TEST',SYSDATE); --MAXVALUE�� 10�̴�
SELECT * FROM DEPTS;

--������ ���� (CREATE�� ALTER�θ� �ٲ�ϴ�)
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;

ALTER SEQUENCE DEPTS_SEQ MAXVALUE 10000 INCREMENT BY 10;

ALTER SEQUENCE DEPTS_SEQ MINVALUE 1; --�ּڰ� 1

SELECT * FROM USER_SEQUENCES;

--�������� �̹� ���ǰ� �ִٸ�, DROP�ϸ� �ȵȴ�.
--�ֱ������� �������� �ʱ�ȭ �Ѵٸ�?
--������ �ʱ�ȭ ���
--������ �������� ������ �ٲٰ� 
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -19 MINVALUE 0;
--�ѹ� ���� ��Ű�� 
SELECT DEPT_SEQ.NEXTVAL FROM DUAL;
--�ٽ� ��������� �ٲ�
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;
--
-------------------------------
--������ ����
--PK�� ������ ���ڿ��� ���� 2023-12-��������
--
CREATE TABLE DEPTS2(
    DEPTS_NO VARCHAR2(30) CONSTRAINT DEPTS2_PK PRIMARY KEY,
    DEPTS_NAME VARCHAR2(30)
);
DROP TABLE DEPTS2;
DROP SEQUENCE DEPTS2_SEQ;
CREATE SEQUENCE DEPTS2_SEQ NOCACHE;

SELECT TO_CHAR(SYSDATE,'YYYY-MM-'), 
        LPAD('X',5,'0'),
        TO_CHAR (SYSDATE , 'YYYY-MM-')||LPAD(DEPTS2_SEQ.NEXTVAL, 5,'0') AS NO
FROM DUAL;

--������ ����
DROP SEQUENCE ��������;

-----------------------------------------------------

--�ε���
--INDEX�� PRIMARY KEY, UNIQUE ���࿡ �ڵ����� �����ǰ� , ��ȸ�� ������ �ϴ� HINT������ �մϴ�
--INDEX�� �����δ� �����ε���, ������ε����� �ֽ��ϴ�.
--UNIQUE�� �÷����� UNIQUE�ε���(�����ε���)�� �� �� �ֽ��ϴ�.
--�Ϲ��÷����� ����� �ε����� ������ �� �ֽ��ϴ�.
--INDEX�� ��ȸ�� ������ ������, �������ϰ� ���� ���Ǵ� ���� ������ �������ϸ� �θ� �� �ֽ��ϴ�.
--�ַ� ���Ǵ� �÷��߿��� SELECT���� �ӵ����ϰ� �ִٸ�, ���� ����غ� ������ �ϳ��� INDEX �Դϴ�.

CREATE TABLE EMPS_IT AS (SELECT * FROM EMPLOYEES);
SELECT * FROM EMPS_IT; 

--�ε����� ������ �ӵ�
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy';

--�� ���� �ε����� ����
CREATE INDEX EMPS_IT_IDX ON EMPS_IT(FIRST_NAME);
--�ε��� ������ �ӵ�
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy';

--�ε��� ����(���̺� ��ü�� ������ ��ġ�� �ʽ��ϴ�)
DROP INDEX EMPS_IT_IDX;
--�ε����� ���� �÷��� ���(�����ε���) ������ ���� �ֽ��ϴ�.
CREATE INDEX EMPS_IT_IDX ON EMPS_IT (FIRST_NAME , LAST_NAME);
--
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy'; -- ��Ʈ�� ����
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy' AND LAST_NAME = 'Greenberg'; --��Ʈ�� ����
SELECT * FROM EMPS_IT WHERE LAST_NAME = 'Greenberg';

--����Ŭ�� ��Ʈ�� (�ε����� �̿��ؼ� ��ȸ ������ ��Ʈ�� ��)

--��Ʈ�� ���� ���ϰ� ��ȸ
SELECT ROWNUM AS RN,
       D.*
FROM DEPTS D
ORDER BY DEPT_NO DESC;

--���� ����
SELECT ROWNUM AS RN,
        D.*
FROM (
    SELECT *
    FROM DEPTS
    ORDER BY DEPT_NO DESC
) D;

--�ε��� ��Ʈ�� �޾Ƽ� ��ȸ
SELECT /*+ INDEX DESC(D DEPTS_NO_PK) */
        ROWNUM AS RN,
        D.*
FROM DEPTS D
ORDER BY DEPT_NO DESC;




