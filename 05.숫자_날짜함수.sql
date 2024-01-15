--�ڵ� ����ȯ
SELECT * FROM EMPLOYEES;
SELECT * FROM EMPLOYEES WHERE SALARY >= '1000'; -- ���� -> ���� �ڵ�����ȯ
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '05/01/01' ; --���� -> ��¥ �ڵ�����ȯ

--��������ȯ
--TO_CHAR -> ��¥ , ���ڷ� ���� ����ȯ , ��¥ ���������� ���δ�
SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') AS TIME FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD') AS TIME FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD AM') AS TIME FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"��" MM"��" DD"��"') FROM DUAL; --����Ʈ ���������� �ƴ� ���� ������ ""�� �����ش�

SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEES;

--TO_CHAR -> ����, ���ڷ� ���� ����ȯ, ���� ���������� ���δ�(9 0, . S L)
SELECT TO_CHAR(20000, '9999999999'), 20000 FROM DUAL; -- ���� 10�ڸ��� ����
SELECT TO_CHAR(20000, '09999999999'), 20000 FROM DUAL; -- ���� 10�ڸ��� ����
SELECT TO_CHAR(20000, '9999'),20000 FROM DUAL; --�ڸ����� �����ϸ� #���� ó�� �ȴ�
SELECT TO_CHAR(20000.123, '99999.999')FROM DUAL; -- �Ҽ����� .���� ��Ÿ����,�� �׳� ����ȴ�
SELECT TO_CHAR(20000, '$999999') AS A FROM DUAL; --$�� �׳� ���� �˴ϴ�.
SELECT TO_CHAR(20000, 'L999999') AS A FROM DUAL; --L�� ����ȭ�� ��ȣ

--������ ȯ���� 1302.69�� �Դϴ�
-- SALARY�÷��� �ѱ������� �����ؼ� �Ҽ��� 2�ڸ������� ���
SELECT FIRST_NAME,TO_CHAR(SALARY*1302.69,'L99999999.00') AS A FROM EMPLOYEES;

--TO_NUMBER ->����, ���ڷ� ���� ����ȯ
SELECT '2000' + 2000 FROM DUAL; -- ���������ȯ
SELECT TO_NUMBER('$5,000', '$9,999')+ 2000 FROM DUAL; --���ڷ� ��ȯ�� ������ ������ ���,���� fmt�� �̿��ؼ� �ڸ��� ���߸��

--TO_DATE -> ����,��¥�� ���� ����ȯ
SELECT TO_DATE('2023-12-04') FROM DUAL; --��¥�� ����ȯ

SELECT SYSDATE - '2023-12-03' FROM DUAL; --��¥�� ��ȯ�ؾ� ���ڰ� ���´�.

SELECT TO_DATE('2023/12/04', 'YYYY/MM/DD') FROM DUAL;
SELECT TO_DATE('2023��12��04��') FROM DUAL; --���˾����� �ȵ�
SELECT TO_DATE('2023��12��04��', 'YYYY"��"MM"��"DD"��"') FROM DUAL;
SELECT '2024-12-04 02:30:23' FROM DUAL;
SELECT TO_DATE('2024-12-04 02:30:23' , 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --�ڸ��� ���缭 ���������� �����ش�

--XXXX�� XX��XX�� �� ��ȯ
SELECT TO_CHAR(TO_DATE('20050102','YYYY-MM-DD'),'YYYY"��" MM"��" DD"��"') FROM DUAL;

