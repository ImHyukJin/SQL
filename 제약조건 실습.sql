--문제 1.
--다음과 같은 테이블을 생성하고 데이터를 insert하세요 (커밋)
--조건) M_NAME 는 가변문자형, 널값을 허용하지 않음
--조건) M_NUM 은 숫자형, 이름(mem_memnum_pk) primary key
--조건) REG_DATE 는 날짜형, 널값을 허용하지 않음, 이름:(mem_regdate_uk) UNIQUE키
--조건) GENDER 가변문자형
--조건) LOCA 숫자형, 이름:(mem_loca_loc_locid_fk) foreign key ? 참조 locations테이블(location_id)

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
--문제 2.
--MEMBERS테이블과 LOCATIONS테이블을 INNER JOIN 하고 m_name, m_mum, street_address, location_id
--컬럼만 조회
--m_num기준으로 오름차순 조회
SELECT * FROM LOCATIONS;

SELECT M_NAME , M_NUM ,STREET_ADDRESS,LOCATION_ID 
FROM MEM M
JOIN LOCATIONS L
ON M.LOCA = L.LOCATION_ID
ORDER BY M_NUM ASC;

select * from mem;