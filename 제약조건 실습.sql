--���� 1.
--������ ���� ���̺��� �����ϰ� �����͸� insert�ϼ��� (Ŀ��)
--����) M_NAME �� ����������, �ΰ��� ������� ����
--����) M_NUM �� ������, �̸�(mem_memnum_pk) primary key
--����) REG_DATE �� ��¥��, �ΰ��� ������� ����, �̸�:(mem_regdate_uk) UNIQUEŰ
--����) GENDER ����������
--����) LOCA ������, �̸�:(mem_loca_loc_locid_fk) foreign key ? ���� locations���̺�(location_id)

CREATE TABLE MEM(
            M_NAME VARCHAR2(10) NOT NULL,
            M_NUM NUMBER(10) CONSTRAINT MEM_MEMNUM_PK PRIMARY KEY,
            REG_DATE DATE NOT NULL CONSTRAINT MEM_REGDATE_UK UNIQUE,
            GENDER VARCHAR(1),
            LOCA NUMBER(10) CONSTRAINT MEM_LOCA_LOC_LOCID_FK REFERENCES LOCATIONS(LOCATION_ID)
);

INSERT INTO MEM VALUES('AAA', 1 , '2018-07-01' , 'M',1800);
INSERT INTO MEM VALUES('BBB', 2 , '2018-07-02' , 'F',1900);
INSERT INTO MEM VALUES('CCC', 3 , '2018-07-03' , 'M',2000);
INSERT INTO MEM VALUES('DDD', 4 , SYSDATE , 'M',2000);

commit;
SELECT * FROM MEM ORDER BY M_NUM;
--���� 2.
--MEMBERS���̺�� LOCATIONS���̺��� INNER JOIN �ϰ� m_name, m_mum, street_address, location_id
--�÷��� ��ȸ
--m_num�������� �������� ��ȸ
SELECT * FROM LOCATIONS;

SELECT M_NAME , M_NUM ,STREET_ADDRESS,LOCATION_ID 
FROM MEM M
JOIN LOCATIONS L
ON M.LOCA = L.LOCATION_ID
ORDER BY M_NUM ASC;

select * from mem;