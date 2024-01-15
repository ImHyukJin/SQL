--���
--IF ~~ THEN
--ELSIF ~~ THEN
--ELSE ~~
--END IF;

SET SERVEROUTPUT ON;

DECLARE
    NUM NUMBER := TRUNC(DBMS_RANDOM.VALUE(1,11)); --1~11�̸��� ������ ����
    NUM2 NUMBER := 5;
BEGIN
    DBMS_OUTPUT.PUT_LINE(NUM);
    
    IF NUM>= NUM2 THEN
        DBMS_OUTPUT.PUT_LINE(NUM || '�� ū�� �Դϴ�');
    ELSE
        DBMS_OUTPUT.PUT_LINE(NUM2 || '�� ū �� �Դϴ�');
    END IF;
END;

--ELSE IF ,CASE WHEN THEN
DECLARE
    RAN_NUM NUMBER := TRUNC(DBMS_RANDOM.VALUE(1,101)); --1~101�̸� ������ ����
BEGIN
/*
    IF RAN_NUM >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('A���� �Դϴ�');
    ELSIF RAN_NUM >= 80 THEN   
        DBMS_OUTPUT.PUT_LINE('B���� �Դϴ�');
    ELSIF RAN_NUM >= 70 THEN   
        DBMS_OUTPUT.PUT_LINE('C���� �Դϴ�');
    ELSE   
        DBMS_OUTPUT.PUT_LINE('D���� �Դϴ�');
     END IF;
*/
    CASE WHEN RAN_NUM>=90 THEN DBMS_OUTPUT.PUT_LINE('A���� �Դϴ�');
         WHEN RAN_NUM>=80 THEN DBMS_OUTPUT.PUT_LINE('B���� �Դϴ�');
         WHEN RAN_NUM>=70 THEN DBMS_OUTPUT.PUT_LINE('C���� �Դϴ�');
         ELSE  DBMS_OUTPUT.PUT_LINE('D���� �Դϴ�');
    END CASE;
END;

----------------------------------------------------
--�ݺ��� WHILE ;

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
--FOR��
DECLARE
    DAN NUMBER := 3;
BEGIN
    FOR I IN 1..9 --1~9���� ���� I�� ��´�
    LOOP
        DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || I || ' = ' || DAN * I);
    END LOOP;
END;
--Ż�⹮ EXIT WHEN ����, CONTINUE WHEN ����
DECLARE
BEGIN

    FOR I IN 1..10
    LOOP
        CONTINUE WHEN I = 5; --NUM�� 5�� ��������
        DBMS_OUTPUT.PUT_LINE(I);
        --EXIT WHEN I = 5; --NUM�� 5�� Ż��
    END LOOP;
    
END;

-------------------------------------------------------------

--Ŀ�� : ���� �������� �������� �� �� �྿ ó���ϴ� ���
--��ȯ�Ǵ� ���� ������ �̱� ������ , ó���� �Ұ���(Ŀ���� �̿��ؼ� ó��)
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
    CURSOR X IS SELECT FIRST_NAME , SALARY FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'; --1. Ŀ�� ����
BEGIN
    OPEN X; --2. Ŀ�� ����
        DBMS_OUTPUT.PUT_LINE('=============Ŀ������===============');
    LOOP
        FETCH X INTO NM , SALARY; -- 4. Ŀ���� �����͸� ������ ����
        EXIT WHEN X%NOTFOUND; -- 5.Ŀ���� ���̻� ���� �����Ͱ� ���ٸ� TRUE
        DBMS_OUTPUT.PUT_LINE(NM);
        DBMS_OUTPUT.PUT_LINE(SALARY);
        
    END LOOP; 
        DBMS_OUTPUT.PUT_LINE('=============Ŀ������================');
        DBMS_OUTPUT.PUT_LINE('������ڵ� �� : ' || X%ROWCOUNT);
    CLOSE X;--3. Ŀ�� ����
END;

--1. ��� �������� ����ϴ� �͸����� ���弼��.
DECLARE
BEGIN
    FOR J IN 1..9
        LOOP
             FOR I IN 1..9 --1~9���� ���� I�� ��´�
                LOOP
                   DBMS_OUTPUT.PUT_LINE(J || ' X ' || I || ' = ' || J * I);
             END LOOP;
        END LOOP;
END;
--2. ù��° ���� rownum�� �̿��ϸ� �˴ϴ�.
--����) 10 ~120������ 10���� ������ ��ȣ�� �̿��ؼ� ���� department_id�� ù��° �ุ select�մϴ�
DECLARE
    NUM NUMBER := TRUNC(DBMS_RANDOM.VALUE(1,13)*10);
BEGIN
    SELECT DEPARTMENT_ID

    FROM EMPLOYEES WHERE DEPARTMENT_ID = NUM;
END;

SELECT
    CASE
    WHEN E.SALARY >= 9000 THEN '����'
    WHEN E.SALARY >= 5000 THEN '�߰�'
    ELSE '����'
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

--����2) ���� ����� SALARY�� 9000�̻��̸� ����,5000�̻��̸� �߰� , �������� �������� ���.

--3. COURSE ���̺� INSERT�� 100�� �����ϴ� �͸����� ó���ϼ���.
--���� ) NUM�� COURSE SEQ�� �̿��ϼ���.
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
--4 �μ��� �޿����� ����ϴ� Ŀ�������� �ۼ�

--5 ������̺��� ������ �޿����� ���Ͽ� EMP_SAL�� ���������� INSERT�ϴ� Ŀ�������� �ۼ�