
--TEST TRIGGER
CREATE TABLE CTDH_LOG 
(
  SOHOADON2 NVARCHAR2(50) NOT NULL 
, MAHANG2 NVARCHAR2(50) NOT NULL 
, UPDATE_DATE DATE
, USERNAME NVARCHAR2(50)
, PRIMARY KEY (SOHOADON2)
);

--

CREATE OR REPLACE TRIGGER TRIGGER1 
AFTER UPDATE OF SOLUONG ON CHITIETDATHANG
FOR EACH ROW
DECLARE
username nvarchar2(20);
BEGIN
  SELECT USER INTO username FROM dual;
  INSERT INTO CTDH_LOG VALUES (:NEW.SOHOADON, :NEW.MAHANG, sysdate, username );
END;

--

CREATE OR REPLACE TRIGGER TRIGGER1 
AFTER UPDATE OF SOLUONG ON CHITIETDATHANG
FOR EACH ROW
WHEN ((NEW.SOLUONG - OLD.SOLUONG) > 50)
DECLARE
username nvarchar2(20);
BEGIN
  SELECT USER INTO username FROM dual;
  INSERT INTO CTDH_LOG VALUES (:NEW.SOHOADON, :NEW.MAHANG, sysdate, username, :NEW.SOLUONG, :OLD.SOLUONG);
END;

--
CREATE TABLE USER_DETAILS
(
	USER_ID number(10) primary key,
	USER_NAME varchar2(15),
	EMAIL varchar2(20),
	PHONE number(12),
	PASSPORT_NO varchar2(10),
	DRIVING_LICENSE_NO varchar2(10)
);
CREATE TABLE USER_REMINDERS
(
	USER_ID number(10),
	REMINDER_TEXT varchar2(200),
	REMINDER_DATE date,
	STATUS varchar2(10)
);
CREATE OR REPLACE TRIGGER TRG_AFTER_INSERT_USER 
AFTER INSERT
  on USER_DETAILS
  FOR EACH ROW

DECLARE
counter number(2);
reminder_text varchar2(200);

BEGIN
counter := 0;
reminder_text := '';

  IF(:NEW.PASSPORT_NO = '' OR :NEW.PASSPORT_NO is null) THEN
    reminder_text := 'Please insert your passport details into system. ';
    counter := counter+1;
  END IF;

  IF(:NEW.DRIVING_LICENSE_NO = '' OR :NEW.DRIVING_LICENSE_NO is null) THEN
    reminder_text := reminder_text || 'Please insert your Driving license details into system.';
    counter := counter+1;
  END IF;

  -- If passport_no and/or driving_license_no is missing
  -- then counter will be >0 and below code will insert into user_reminders table.
  IF(counter>0) THEN
    INSERT INTO USER_REMINDERS VALUES (:NEW.USER_ID,reminder_text,sysdate+3,'PENDING');
  END IF;

END;

-- fire after insert trigger, no action.
INSERT INTO USER_DETAILS VALUES (1,'USERNM1','abcdxyz@abc.com',9999999999,'PASSNUM123','DRIVLIC999');

-- fire after insert trigger, password is null, insert new record into USER_REMINDERS
INSERT INTO USER_DETAILS VALUES (2,'USERNM22','xyzabcd@abc.com',1111111111,null,'LICNC12345');

-- fire after insert trigger, password and driving no are null, insert new record into USER_REMINDERS
INSERT INTO USER_DETAILS VALUES (3,'USERNM33','xyztttt@abc.com',3333333333,null,null);

-- fire after insert trigger, driving no is null, insert new record into USER_REMINDERS
INSERT INTO USER_DETAILS VALUES (4,'USERNM44','ghijkl@abc.com',4444444444,'ONLYPASS11',null);

--

CREATE OR REPLACE TRIGGER TRIGGER1 
BEFORE UPDATE OF SOLUONG
  on CHITIETDATHANG
  FOR EACH ROW
DECLARE
BEGIN
   -- Check whether years_since_last_applied is greater than 2 years or not
    IF (:NEW.SOLUONG < 1) THEN
      RAISE_APPLICATION_ERROR(-20000,'Không thực hiện được, SOLUONG phải >=1');
    END IF;
END;

--

CREATE OR REPLACE TRIGGER TRIGGER1 
BEFORE INSERT ON CHITIETDATHANG
FOR EACH ROW
DECLARE
BEGIN
    --Kiểm tra số lượng hàng trước khi update ở bảng CHITIETDATHANG
    IF (:NEW.SOLUONG < 1) THEN
      RAISE_APPLICATION_ERROR(-20000,'Không thực hiện được, SOLUONG phải >=1');
    END IF;
    --Thay đổi số lượng hàng ở bảng MATHANG, thêm số lượng hàng ở bảng CHITIETDATHANG
    IF (:NEW.SOLUONG >= 1) THEN
      UPDATE TUAN.MATHANG mh
      SET mh.SOLUONG = (mh.SOLUONG-:NEW.SOLUONG)
      WHERE mh.MAHANG=:NEW.MAHANG;
    END IF;
END;

CREATE OR REPLACE TRIGGER TRIGGER1 
BEFORE UPDATE OF SOLUONG ON CHITIETDATHANG
FOR EACH ROW
DECLARE
BEGIN
    --Kiểm tra số lượng hàng trước khi update ở bảng CHITIETDATHANG
    IF (:NEW.SOLUONG < 1) THEN
      RAISE_APPLICATION_ERROR(-20000,'Không thực hiện được, SOLUONG phải >=1');
    END IF;
    --Thay đổi số lượng hàng ở bảng MATHANG, sau khi cập nhật số lượng hàng ở bảng CHITIETDATHANG
    IF (:NEW.SOLUONG >= 1) THEN
      UPDATE TUAN.MATHANG mh
      SET mh.SOLUONG = (mh.SOLUONG+:OLD.SOLUONG-:NEW.SOLUONG)
      WHERE mh.MAHANG=:NEW.MAHANG;
    END IF;
END;

--


