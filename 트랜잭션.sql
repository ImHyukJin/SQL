--Ʈ����� (�۾��� ������ ����)
--���� DML���� ���ؼ��� Ʈ������� ������ �� �ֽ��ϴ�.

--����Ŀ�� ���� Ȯ��
SHOW AUTOCOMMIT;
--����Ŀ�� ��
SET AUTOCOMMIT ON;
--����Ŀ�� ����
SET AUTOCOMMIT OFF;

-----------------------------------
--SAVE POINT (������ ���� ���� ����)
SELECT * FROM DEPTS;
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 10;

SAVEPOINT DEL10 ; -- DEL10 ���̺�����Ʈ

DELETE FROM DEPTS WHERE DEPARTMENT_ID = 20;

SAVEPOINT DEL20 ; -- DEL20 ���̺�����Ʈ

DELETE FROM DEPTS WHERE DEPARTMENT_ID = 30;

ROLLBACK TO DEL20;
SELECT * FROM DEPTS;

ROLLBACK TO DEL10;
SELECT * FROM DEPTS;

ROLLBACK; --������ Ŀ�Խ������� �ѹ�

--Ŀ��(���� �ݿ�)
INSERT INTO DEPTS VALUES(280, 'AAA',NULL,1800);

COMMIT;

SELECT * FROM DEPTS;