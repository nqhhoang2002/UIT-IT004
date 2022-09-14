
----------------------------------------BUOI1----------------

CREATE DATABASE TH

USE TH

SET DATEFORMAT DMY

/*
	1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính
	GHICHU, DIEMTB, XEPLOAI cHO quan hệ HOCVIEN.
*/

CREATE TABLE HOCVIEN(
	MAHV CHAR(5),
	HO NVARCHAR(40), -- unicode
	TEN NVARCHAR(10), -- unicode
	NGSINH SMALLDATETIME,
	GIOITINH NVARCHAR(3), -- unicode
	NOISINH NVARCHAR(40), -- unicode
	MALOP CHAR(3),
	PRIMARY KEY (MAHV)
)

CREATE TABLE LOP(
	MALOP CHAR(3),
	TENLOP NVARCHAR(40), -- unicode
	TRGLOP CHAR(5),
	SISO TINYINT,
	MAGVCN CHAR(4),
	PRIMARY KEY (MALOP)
)

CREATE TABLE KHOA(
	MAKHOA VARCHAR(4),
	TENKHOA NVARCHAR(40), -- unicode
	NGTLAP SMALLDATETIME,
	TRGKHOA CHAR(4),
	PRIMARY KEY (MAKHOA)
)

CREATE TABLE MONHOC(
	MAMH VARCHAR(10),
	TENMH NVARCHAR(40), -- unicode
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4),
	PRIMARY KEY (MAMH)
)

CREATE TABLE DIEUKIEN(
	MAMH VARCHAR(10),
	MAMH_TRUOC VARCHAR(10),
	PRIMARY KEY (MAMH, MAMH_TRUOC)
)

CREATE TABLE GIAOVIEN(
	MAGV CHAR(4),
	HOTEN NVARCHAR(40), -- unicode
	HOCVI NVARCHAR(10), -- unicdoe
	HOCHAM NVARCHAR(10), -- unicdoe
	GIOITINH NVARCHAR(3), -- unicode
	NGSINH SMALLDATETIME,
	NGVL SMALLDATETIME,
	HESO NUMERIC(4, 2),
	MUCLUONG MONEY,
	MAKHOA VARCHAR(4),
	PRIMARY KEY (MAGV)
)

CREATE TABLE GIANGDAY(
	MALOP CHAR(3),
	MAMH VARCHAR(10),
	MAGV CHAR(4),
	HOCKY TINYINT,
	NAM SMALLINT,
	TUNGAY SMALLDATETIME,
	DENNGAY SMALLDATETIME,
	PRIMARY KEY (MALOP, MAMH)
)

CREATE TABLE KETQUATHI(
	MAHV CHAR(5),
	MAMH VARCHAR(10),
	LANTHI TINYINT,
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4, 2),
	KQUA VARCHAR(10),
	PRIMARY KEY (MAHV, MAMH, LANTHI)
)

/*
	Thêm khóa ràng buộc khóa ngoại
*/

ALTER TABLE KHOA
ADD CONSTRAINT FK_KHOA_TRGKHOA FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE MONHOC
ADD CONSTRAINT FK_MONHOC_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE DIEUKIEN
ADD CONSTRAINT FK_DIEUKIEN_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE DIEUKIEN
ADD CONSTRAINT FK_DIEUKIEN_MAMH_TRUOC FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)

ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV)

ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_MAGVCN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE HOCVIEN
ADD CONSTRAINT FK_HOCVIEN_MALOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)

ALTER TABLE GIANGDAY
ADD CONSTRAINT FK_GIANGDAY_MALOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)

ALTER TABLE GIANGDAY
ADD CONSTRAINT FK_GIANGDAY_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE KETQUATHI
ADD CONSTRAINT FK_KETQUATHI_MAHV FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV)

ALTER TABLE KETQUATHI
ADD CONSTRAINT FK_KETQUATHI_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)


/*
	2. Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học
	viên trong lớp. VD: “K1101”
*/
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHECK_MAHV CHECK((SUBSTRING(MAHV, 1, 3) = MALOP) AND ISNUMERIC(SUBSTRING(MAHV, 4, 5)) = 1)



/*
	3. Thuộc tính GIOITINH chỉ có giá trị là 'Nam' HOặc 'Nữ'.
*/
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHECK_GT_HV CHECK(GIOITINH IN (N'Nam', N'Nữ'))

ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_GT_GV CHECK(GIOITINH IN (N'Nam', N'Nữ'))

--Alter table dbo.HOCVIEN drop CONSTRAINT CHECK_GT_HV
--Alter table dbo.GIAOVIEN drop CONSTRAINT CHECK_GT_GV


/*
	4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22)
*/
-- Do DIEM là NUMERIC(4, 2) nên không cần tính phần thập phân nữa
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHECK_DIEM CHECK(DIEM BETWEEN 0 AND 10) 


/*
	Insert 8 bảng
*/

---------------- INSERT KHOA -----------------------------
SET DATEFORMAT DMY

INSERT INTO KHOA(MAKHOA, TENKHOA, NGTLAP) VALUES('KHMT', N'KHOa học máy tính', '07/06/2005')
INSERT INTO KHOA(MAKHOA, TENKHOA, NGTLAP) VALUES('HTTT', N'Hệ thống thông tin', '07/06/2005')
INSERT INTO KHOA(MAKHOA, TENKHOA, NGTLAP) VALUES('CNPM', N'Công nghệ phần mềm', '07/06/2005')
INSERT INTO KHOA(MAKHOA, TENKHOA, NGTLAP) VALUES('MTT', N'Mạng và truyền thông', '20/10/2005')
INSERT INTO KHOA(MAKHOA, TENKHOA, NGTLAP) VALUES('KTMT', N'Kỹ thuật máy tính', '20/12/2005')

------------------- INSERT GIAOVIEN --------------------------

INSERT INTO GIAOVIEN VALUES('GV01', N'HO Thanh Son', N'PTS', N'GS', N'Nam', '02/05/1950', '11/01/2004', 5.00, 2250000, 'KHMT')
INSERT INTO GIAOVIEN VALUES('GV02', N'Tran Tam Thanh', N'TS', N'PGS', N'Nam', '17/12/1965', '20/04/2004', 4.50, 2025000, 'HTTT')
INSERT INTO GIAOVIEN VALUES('GV03', N'Do Nghiem Phung', N'TS', N'GS', N'Nữ', '01/08/1950', '23/09/2004', 4.00, 1800000, 'CNPM')
INSERT INTO GIAOVIEN VALUES('GV04', N'Tran Nam Son', N'TS', N'PGS', N'Nam', '22/02/1961', '12/01/2005', 4.50, 2025000, 'KTMT')
INSERT INTO GIAOVIEN VALUES('GV05', N'Mai Thanh Danh', N'ThS', N'GV', N'Nam', '12/03/1958', '12/01/2005', 3.00, 1350000, 'HTTT')
INSERT INTO GIAOVIEN VALUES('GV06', N'Tran Doan Hung', N'TS', N'GV', N'Nam', '11/03/1953', '12/01/2005', 4.50, 2025000, 'KHMT')
INSERT INTO GIAOVIEN VALUES('GV07', N'Nguyen Minh Tien', N'ThS', N'GV', N'Nam', '23/11/1971', '01/03/2005', 4.00, 1800000, 'KTMT')
INSERT INTO GIAOVIEN VALUES('GV08', N'Le Thi Tran', N'KS', N'NULL', N'Nữ', '26/03/1974', '01/03/2005', 1.69, 760500, 'KHMT')
INSERT INTO GIAOVIEN VALUES('GV09', N'Nguyen To Lan', N'ThS', N'GV', N'Nữ', '31/12/1966', '01/03/2005', 4.00, 1800000, 'HTTT')
INSERT INTO GIAOVIEN VALUES('GV10', N'Le Tran Anh Loan', N'KS', N'NULL', N'Nữ', '17/07/1972', '01/03/2005', 1.86, 837000, 'CNPM')
INSERT INTO GIAOVIEN VALUES('GV11', N'HO Thanh Tung', N'CN', N'GV', N'Nam', '12/01/1980', '15/05/2005', 2.67, 1201500, 'MTT')
INSERT INTO GIAOVIEN VALUES('GV12', N'Tran Van Anh', N'CN', N'NULL', N'Nữ', '29/03/1981', '15/05/2005', 1.69, 760500, 'CNPM')
INSERT INTO GIAOVIEN VALUES('GV13', N'Nguyen Linh Dan', N'CN', N'NULL', N'Nữ', '23/05/1980', '15/05/2005', 1.69, 760500, 'KTMT')
INSERT INTO GIAOVIEN VALUES('GV14', N'Truong Minh Chau', N'Ths', N'GV', N'Nữ', '30/11/1976', '15/05/2005', 3.00, 1350000, 'MTT')
INSERT INTO GIAOVIEN VALUES('GV15', N'Le Ha Thanh', N'ThS', N'GV', N'Nam', '04/05/1978', '15/05/2005', 3.00, 1350000, 'KHMT')

UPDATE KHOA SET TRGKHOA = 'GV01' WHERE MAKHOA = 'KTMT'
UPDATE KHOA SET TRGKHOA = 'GV02' WHERE MAKHOA = 'HTTT'
UPDATE KHOA SET TRGKHOA = 'GV04' WHERE MAKHOA = 'CNPM'
UPDATE KHOA SET TRGKHOA = 'GV03' WHERE MAKHOA = 'MTT'

-------------------- INSERT LOP ---------------------------

INSERT INTO LOP(MALOP, TENLOP, SISO, MAGVCN) VALUES('K11', N'Lớp 1 khóa 1', 11, 'GV07')
INSERT INTO LOP(MALOP, TENLOP, SISO, MAGVCN) VALUES('K12', N'Lớp 2 khóa 1', 12, 'GV09')
INSERT INTO LOP(MALOP, TENLOP, SISO, MAGVCN) VALUES('K13', N'Lớp 3 khóa 1', 12, 'GV14')


-------------------------------INSERT HOCVIEN-----------------------------

SET DATEFORMAT DMY
INSERT INTO HOCVIEN VALUES('K1101', N'Nguyen Van', N'A', '27/01/1986', N'Nam', N'TpHCM', 'K11')
INSERT INTO HOCVIEN VALUES('K1102', N'Tran Ngoc', N'Han', '14/03/1986', N'Nữ', N'Kien Giang', 'K11')
INSERT INTO HOCVIEN VALUES('K1103', N'Ha Duy', N'Lap', '18/04/1986', N'Nam', N'Nghe An', 'K11')
INSERT INTO HOCVIEN VALUES('K1104', N'Tran Ngoc', N'Linh', '30/03/1986', N'Nữ', N'Tay Ninh', 'K11')
INSERT INTO HOCVIEN VALUES('K1105', N'Tran Minh', N'Long', '27/02/1986', N'Nam', N'TpHCM', 'K11')
INSERT INTO HOCVIEN VALUES('K1106', N'Le Nhat', N'Minh', '24/01/1986', N'Nam', N'TpHCM', 'K11')
INSERT INTO HOCVIEN VALUES('K1107', N'Nguyen Nhu', N'Nhut', '27/01/1986', N'Nam', N'Ha Noi', 'K11')
INSERT INTO HOCVIEN VALUES('K1108', N'Nguyen Manh', N'Tam', '27/02/1986', N'Nam', N'Kien Giang', 'K11')
INSERT INTO HOCVIEN VALUES('K1109', N'Phan Thi Thanh', N'Tam', '27/01/1986', N'Nữ', N'Vinh Long', 'K11')
INSERT INTO HOCVIEN VALUES('K1110', N'Le HOai', N'Thuong', '05/02/1986', N'Nữ', N'Can THO', 'K11')
INSERT INTO HOCVIEN VALUES('K1111', N'Le Ha', N'Vinh', '25/12/1986', N'Nam', N'Vinh Long', 'K11')
INSERT INTO HOCVIEN VALUES('K1201', N'Nguyen Van', N'B', '11/02/1986', N'Nam', N'TpHCM', 'K12')
INSERT INTO HOCVIEN VALUES('K1202', N'Nguyen Thi Kim', N'Duyen', '18/01/1986', N'Nữ', N'TpHCM', 'K12')
INSERT INTO HOCVIEN VALUES('K1203', N'Tran Thi Kim', N'Duyen', '17/09/1986', N'Nữ', N'TpHCM', 'K12')
INSERT INTO HOCVIEN VALUES('K1204', N'Truong My', N'Hanh', '19/05/1986', N'Nữ', N'Dong Nai', 'K12')
INSERT INTO HOCVIEN VALUES('K1205', N'Nguyen Thanh', N'Nam', '17/04/1986', N'Nam', N'TpHCM', 'K12')
INSERT INTO HOCVIEN VALUES('K1206', N'Nguyen Thi Truc', N'Thanh', '04/03/1986', N'Nữ', N'Kien Giang', 'K12')
INSERT INTO HOCVIEN VALUES('K1207', N'Tran Thi Bich', N'Thuy', '08/02/1986', N'Nữ', N'Nghe An', 'K12')
INSERT INTO HOCVIEN VALUES('K1208', N'Huynh Thi Kim', N'Trieu', '08/04/1986', N'Nữ', N'Tay Ninh', 'K12')
INSERT INTO HOCVIEN VALUES('K1209', N'Pham Thanh', N'Trieu', '23/02/1986', N'Nam', N'TpHCM', 'K12')
INSERT INTO HOCVIEN VALUES('K1210', N'Ngo Thanh', N'Tuan', '14/02/1986', N'Nam', N'TpHCM', 'K12')
INSERT INTO HOCVIEN VALUES('K1211', N'Do Thi', N'Xuan', '09/03/1986', N'Nữ', N'Ha Noi', 'K12')
INSERT INTO HOCVIEN VALUES('K1212', N'Le Thi Phi', N'Yen', '12/03/1986', N'Nữ', N'TpHCM', 'K12')
INSERT INTO HOCVIEN VALUES('K1301', N'Nguyen Thi Kim', N'Cuc', '09/06/1986', N'Nữ', N'Kien Giang', 'K13')
INSERT INTO HOCVIEN VALUES('K1302', N'Truong Thi My', N'Hien', '18/03/1986', N'Nữ', N'Nghe An', 'K13')
INSERT INTO HOCVIEN VALUES('K1303', N'Le Duc', N'Hien', '21/03/1986', N'Nam', N'Tay Ninh', 'K13')
INSERT INTO HOCVIEN VALUES('K1304', N'Le Quang', N'Hien', '18/04/1986', N'Nam', N'TpHCM', 'K13')
INSERT INTO HOCVIEN VALUES('K1305', N'Le Thi', N'Huong', '27/03/1986', N'Nữ', N'TpHCM', 'K13')
INSERT INTO HOCVIEN VALUES('K1306', N'Nguyen Thai', N'Huu', '30/03/1986', N'Nam', N'Ha Noi', 'K13')
INSERT INTO HOCVIEN VALUES('K1307', N'Tran Minh', N'Man', '28/05/1986', N'Nam', N'TpHCM', 'K13')
INSERT INTO HOCVIEN VALUES('K1308', N'Nguyen Hieu', N'Nghia', '08/04/1986', N'Nam', N'Kien Giang', 'K13')
INSERT INTO HOCVIEN VALUES('K1309', N'Nguyen Trung', N'Nghia', '18/01/1987', N'Nam', N'Nghe An', 'K13')
INSERT INTO HOCVIEN VALUES('K1310', N'Tran Thi HOng', N'Tham', '22/04/1986', N'Nữ', N'Tay Ninh', 'K13')
INSERT INTO HOCVIEN VALUES('K1311', N'Tran Minh', N'Thuc', '04/04/1986', N'Nam', N'TpHCM', 'K13')
INSERT INTO HOCVIEN VALUES('K1312', N'Nguyen Thi Kim', N'Yen', '07/09/1986', N'Nữ', N'TpHCM', 'K13')

UPDATE LOP SET TRGLOP = 'K1108' WHERE MALOP = 'K11'
UPDATE LOP SET TRGLOP = 'K1205' WHERE MALOP = 'K12'
UPDATE LOP SET TRGLOP = 'K1305' WHERE MALOP = 'K13'


------------------- INSERT MONHOC ----------------------------

INSERT INTO MONHOC VALUES('THDC', N'Tin học đại cương', 4, 1, 'KHMT')
INSERT INTO MONHOC VALUES('CTRR', N'Cấu trúc rời rạc', 5, 0, 'KHMT')
INSERT INTO MONHOC VALUES('CSDL', N'Cơ sở dữ liệu', 0, 0, 'HTTT')
INSERT INTO MONHOC VALUES('CTDLGT', N'Cấu trúc dữ liệu và giải thuật', 3, 1, 'KHMT')
INSERT INTO MONHOC VALUES('PTTKTT', N'Phân tích thiết kế thuật toán', 3, 0, 'KHMT')
INSERT INTO MONHOC VALUES('DHMT', N'Đồ họa máy tính', 3, 1, 'KHMT')
INSERT INTO MONHOC VALUES('KTMT', N'Kiến trúc máy tính', 3, 0, 'KTMT')
INSERT INTO MONHOC VALUES('TKCSDL', N'Thiết kế cơ sở dữ liệu', 3, 1, 'HTTT')
INSERT INTO MONHOC VALUES('PTTKHTTT', N'Phân tích thiết kế hệ thống thông tin', 4, 1, 'HTTT')
INSERT INTO MONHOC VALUES('HDH', N'Hệ điều hành', 4, 0, 'KTMT')
INSERT INTO MONHOC VALUES('NMCNPM', N'Nhập môn công nghệ phần mềm', 3, 0, 'CNPM')
INSERT INTO MONHOC VALUES('LTCFW', N'Lập trình C for win', 3, 1, 'CNPM')
INSERT INTO MONHOC VALUES('LTHDT', N'Lập trình hướng đối tượng', 3, 1, 'CNPM')


-------------------- INSERT GIANGDAY -------------------------
INSERT INTO GIANGDAY VALUES('K11', 'THDC', 'GV07', 1, 2006, '02/01/2006', '12/05/2006')
INSERT INTO GIANGDAY VALUES('K12', 'THDC', 'GV06', 1, 2006, '02/01/2006', '12/05/2006')
INSERT INTO GIANGDAY VALUES('K13', 'THDC', 'GV15',  1, 2006, '02/01/2006', '12/05/2006')
INSERT INTO GIANGDAY VALUES('K11', 'CTRR', 'GV02', 1, 2006, '09/01/2006', '17/05/2006')
INSERT INTO GIANGDAY VALUES('K12', 'CTRR', 'GV02', 1, 2006, '09/01/2006', '17/05/2006')
INSERT INTO GIANGDAY VALUES('K13', 'CTRR', 'GV08', 1, 2006, '09/01/2006', '17/05/2006')
INSERT INTO GIANGDAY VALUES('K11', 'CSDL', 'GV05', 2, 2006, '01/06/2006', '15/07/2006')
INSERT INTO GIANGDAY VALUES('K12', 'CSDL', 'GV09', 2, 2006, '01/06/2006', '15/07/2006')
INSERT INTO GIANGDAY VALUES('K13', 'CTDLGT', 'GV15', 2, 2006, '01/06/2006', '15/07/2006')
INSERT INTO GIANGDAY VALUES('K13', 'CSDL', 'GV05', 3, 2006, '01/08/2006', '15/12/2006')
INSERT INTO GIANGDAY VALUES('K13', 'DHMT', 'GV07', 3, 2006, '01/08/2006', '15/12/2006')
INSERT INTO GIANGDAY VALUES('K11', 'CTDLGT', 'GV15', 3, 2006, '01/08/2006', '15/12/2006')
INSERT INTO GIANGDAY VALUES('K12', 'CTDLGT', 'GV15', 3, 2006, '01/08/2006', '15/12/2006')
INSERT INTO GIANGDAY VALUES('K11', 'HDH', 'GV04', 1, 2007, '02/01/2007', '18/02/2007')
INSERT INTO GIANGDAY VALUES('K12', 'HDH', 'GV04', 1, 2007, '02/01/2007', '20/03/2007')
INSERT INTO GIANGDAY VALUES('K11', 'DHMT', 'GV07', 1, 2007, '18/02/2007', '20/03/2007')


-------------------------------INSERT DIEUKIEN----------------------------

INSERT INTO DIEUKIEN VALUES('CSDL ', 'CTRR')
INSERT INTO DIEUKIEN VALUES('CSDL ', 'CTDLGT')
INSERT INTO DIEUKIEN VALUES('PTTKTT ', 'THDC')
INSERT INTO DIEUKIEN VALUES('PTTKTT ', 'CTDLGT')
INSERT INTO DIEUKIEN VALUES('DHMT ', 'THDC')
INSERT INTO DIEUKIEN VALUES('LTHDT ', 'THDC')
INSERT INTO DIEUKIEN VALUES('PTTKHTTT ', 'CSDL')


-------------------------------INSERT KETQUATHI------------------------------------------

INSERT INTO KETQUATHI VALUES('K1101 ', 'CSDL', 1, '20/07/2006', 10.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1101 ', 'CTDLGT', 1, '28/12/2006', 9.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1101 ', 'THDC', 1, '20/05/2006', 9.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1101 ', 'CTRR', 1, '13/05/2006', 9.50, 'Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'CSDL', 1, '20/07/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'CSDL', 2, '27/07/2006', 4.25, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'CSDL', 3, '10/08/2006', 4.50, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'CTDLGT', 1, '28/12/2006', 4.50, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'CTDLGT', 2, '05/01/2007', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'CTDLGT', 3, '15/01/2007', 6.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'THDC', 1, '20/05/2006', 5.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1102 ', 'CTRR', 1, '13/05/2006', 7.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1103 ', 'CSDL', 1, '20/07/2006', 3.50, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1103 ', 'CSDL', 2, '27/07/2006', 8.25, 'Dat')
INSERT INTO KETQUATHI VALUES('K1103 ', 'CTDLGT', 1, '28/12/2006', 7.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1103 ', 'THDC', 1, '20/05/2006', 8.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1103 ', 'CTRR', 1, '13/05/2006', 6.50, 'Dat')
INSERT INTO KETQUATHI VALUES('K1104 ', 'CSDL', 1, '20/07/2006', 3.75, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104 ', 'CTDLGT', 1, '28/12/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104 ', 'THDC', 1, '20/05/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104 ', 'CTRR', 1, '13/05/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104 ', 'CTRR', 2, '20/05/2006', 3.50, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104 ', 'CTRR', 3, '30/06/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1201 ', 'CSDL', 1, '20/07/2006', 6.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1201 ', 'CTDLGT', 1, '28/12/2006', 5.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1201 ', 'THDC', 1, '20/05/2006', 8.50, 'Dat')
INSERT INTO KETQUATHI VALUES('K1201 ', 'CTRR', 1, '13/05/2006', 9.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'CSDL', 1, '20/07/2006', 8.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'CTDLGT', 1, '28/12/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'CTDLGT', 2, '05/01/2007', 5.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'THDC', 1, '20/05/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'THDC', 2, '27/05/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'CTRR', 1, '13/05/2006', 3.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'CTRR', 2, '20/05/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202 ', 'CTRR', 3, '30/06/2006', 6.25, 'Dat')
INSERT INTO KETQUATHI VALUES('K1203 ', 'CSDL', 1, '20/07/2006', 9.25, 'Dat')
INSERT INTO KETQUATHI VALUES('K1203 ', 'CTDLGT', 1, '28/12/2006', 9.50, 'Dat')
INSERT INTO KETQUATHI VALUES('K1203 ', 'THDC', 1, '20/05/2006', 10.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1203 ', 'CTRR', 1, '13/05/2006', 10.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1204 ', 'CSDL', 1, '20/07/2006', 8.50, 'Dat')
INSERT INTO KETQUATHI VALUES('K1204 ', 'CTDLGT', 1, '28/12/2006', 6.75, 'Dat')
INSERT INTO KETQUATHI VALUES('K1204 ', 'THDC', 1, '20/05/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1204 ', 'CTRR', 1, '13/05/2006', 6.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1301 ', 'CSDL', 1, '20/12/2006', 4.25, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1301 ', 'CTDLGT', 1, '25/07/2006', 8.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1301 ', 'THDC', 1, '20/05/2006', 7.75, 'Dat')
INSERT INTO KETQUATHI VALUES('K1301 ', 'CTRR', 1, '13/05/2006', 8.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1302 ', 'CSDL', 1, '20/12/2006', 6.75, 'Dat')
INSERT INTO KETQUATHI VALUES('K1302 ', 'CTDLGT', 1, '25/07/2006', 5.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1302 ', 'THDC', 1, '20/05/2006', 8.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1302 ', 'CTRR', 1, '13/05/2006', 8.50, 'Dat')
INSERT INTO KETQUATHI VALUES('K1303 ', 'CSDL', 1, '20/12/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303 ', 'CTDLGT', 1, '25/07/2006', 4.50, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303 ', 'CTDLGT', 2, '07/08/2006', 4.00, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303 ', 'CTDLGT', 3, '15/08/2006', 4.25, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303 ', 'THDC', 1, '20/05/2006', 4.50, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303 ', 'CTRR', 1, '13/05/2006', 3.25, 'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303 ', 'CTRR', 2, '20/05/2006', 5.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1304 ', 'CSDL', 1, '20/12/2006', 7.75, 'Dat')
INSERT INTO KETQUATHI VALUES('K1304 ', 'CTDLGT', 1, '25/07/2006', 9.75, 'Dat')
INSERT INTO KETQUATHI VALUES('K1304 ', 'THDC', 1, '20/05/2006', 5.50, 'Dat')
INSERT INTO KETQUATHI VALUES('K1304 ', 'CTRR', 1, '13/05/2006', 5.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1305 ', 'CSDL', 1, '20/12/2006', 9.25, 'Dat')
INSERT INTO KETQUATHI VALUES('K1305 ', 'CTDLGT', 1, '25/07/2006', 10.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1305 ', 'THDC', 1, '20/05/2006', 8.00, 'Dat')
INSERT INTO KETQUATHI VALUES('K1305 ', 'CTRR', 1, '13/05/2006', 10.00, 'Dat')

/*
	Thêm vào 3 thuộc tính
	GHICHU, DIEMTB, XEPLOAI cHO quan hệ HOCVIEN.
*/

ALTER TABLE HOCVIEN
ADD GHICHU NVARCHAR(100)

ALTER TABLE HOCVIEN
ADD DIEMTB FLOAT(10)

ALTER TABLE HOCVIEN
ADD XEPLOAI NVARCHAR(10) -- unicode



------------------------------------------------BUOI2----------------------------------------------------
-- II Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):

--	II 1. Tăng hệ số lương thêm 0.2 cHO những giáo viên là trưởng kHOa
UPDATE GIAOVIEN
SET HESO = HESO + 0.2
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA WHERE TRGKHOA IS NOT NULL)

SELECT *
FROM GIAOVIEN

/*
	II 2. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các
môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau
cùng). 
*/

UPDATE HOCVIEN
SET DIEMTB = (
	SELECT AVG(DIEM)
	FROM KETQUATHI
	WHERE LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE HOCVIEN.MAHV = KETQUATHI.MAHV GROUP BY MAHV)
	GROUP BY MAHV
	HAVING HOCVIEN.MAHV = KETQUATHI.MAHV
)


SELECT *
FROM HOCVIEN


/*
	II 3. Cập nhật giá trị cHO cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất
kỳ thi lần thứ 3 dưới 5 điểm.
*/
--ALTER TABLE HOCVIEN ADD GHICHU NVARCHAR(100)
--ALTER TABLE HOCVIEN DROP COLUMN GHICHU

UPDATE HOCVIEN
SET GHICHU = N'CẤM THI'
WHERE EXISTS(SELECT * FROM KETQUATHI WHERE HOCVIEN.MAHV = KETQUATHI.MAHV and LANTHI = 3 AND DIEM < 5)


SELECT * 
FROM KETQUATHI
WHERE LANTHI = 3 AND DIEM < 5

SELECT *
FROM HOCVIEN
WHERE GHICHU = N'CẤM THI'

/*
	II 4. Cập nhật giá trị cHO cột XEPLOAI trong quan hệ HOCVIEN như sau:
	o Nếu DIEMTB >= 9 thì XEPLOAI =”XS”
	o Nếu 8 <= DIEMTB < 9 thì XEPLOAI = “G”
	o Nếu 6.5 <= DIEMTB < 8 thì XEPLOAI = “K”
	o Nếu 5 <= DIEMTB < 6.5 thì XEPLOAI = “TB”
	o Nếu DIEMTB < 5 thì XEPLOAI = ”Y”
*/

ALTER TABLE HOCVIEN ADD XEPLOAI NVARCHAR(10)
ALTER TABLE HOCVIEN DROP COLUMN XEPLOAI

UPDATE HOCVIEN
SET XEPLOAI = N'XS'
WHERE DIEMTB >= 9

UPDATE HOCVIEN
SET XEPLOAI = N'G'
WHERE 8 <= DIEMTB AND DIEMTB < 9

UPDATE HOCVIEN
SET XEPLOAI = N'K'
WHERE 6.5 <= DIEMTB AND DIEMTB < 8

UPDATE HOCVIEN
SET XEPLOAI = N'TB'
WHERE 5 <= DIEMTB AND DIEMTB < 6.5

UPDATE HOCVIEN
SET XEPLOAI = N'Y'
WHERE DIEMTB < 5

SELECT *
FROM HOCVIEN

-- III. Ngôn ngữ truy vấn dữ liệu:
--	III 1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MAHV, HO, TEN, NGSINH, LOP.MALOP
FROM HOCVIEN JOIN LOP
ON LOP.TRGLOP = HOCVIEN.MAHV

/*	
	III 2. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”,
sắp xếp theo tên, họ học viên. */
SELECT HOCVIEN.MAHV, HO, TEN, LANTHI, DIEM
FROM HOCVIEN JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE KETQUATHI.MAMH = 'CTRR' AND HOCVIEN.MALOP = 'K12'
ORDER BY HOCVIEN.TEN ASC, HOCVIEN.HO ASC

/*
	III 3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi
lần thứ nhất đã đạt.
*/
SELECT HOCVIEN.MAHV, (HO+' '+TEN) HOTEN, TENMH
FROM HOCVIEN, KETQUATHI, MONHOC
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV 
	AND KETQUATHI.MAMH = MONHOC.MAMH 
	AND LANTHI = 1 
	AND KQUA = 'Dat'

/*
	III 4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở
lần thi 1).
*/
SELECT HOCVIEN.MAHV, (HO+' '+TEN) HOTEN
FROM HOCVIEN JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE HOCVIEN.MALOP = 'K11' 
	AND KETQUATHI.MAMH = 'CTRR' 
	AND LANTHI = 1 
	AND KQUA = 'Khong Dat'



---------------------------------------------BUOI3------------------------------------------------
/*
	III 5. * Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả
các lần thi).
*/

SELECT DISTINCT HOCVIEN.MAHV, (HO+' '+TEN) HOTEN
FROM HOCVIEN JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE LEFT(MALOP, 1) = 'K' 
	AND HOCVIEN.MAHV NOT IN (SELECT MAHV
							FROM KETQUATHI
							WHERE MAMH = 'CTRR' AND KQUA = 'Dat')

/*
	III 6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
	-- Làm thêm: 
	-- 1. Các lớp mà GV Trần Tâm Thanh đã dạy trong hk1 năm 2006 
	-- 2. Thông tin lớp trưởng của các lớp mà GV Trần Tâm Thanh đã dạy trong hk1 năm 2006 
	-- 3. Các lớp mà GV Trần Tâm Thanh đã dạy "Cấu Trúc Rời Rạc" trong hk1 năm 2006
*/
SELECT DISTINCT MONHOC.TENMH
FROM GIANGDAY JOIN GIAOVIEN ON GIANGDAY.MAGV = GIAOVIEN.MAGV
	JOIN MONHOC ON MONHOC.MAMH = GIANGDAY.MAMH
WHERE GIAOVIEN.HOTEN = N'Tran Tam Thanh' 
	AND GIANGDAY.HOCKY = 1 
	AND GIANGDAY.NAM = 2006

/*
	III 7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy
trong học kỳ 1 năm 2006
*/
SELECT DISTINCT MONHOC.MAMH, MONHOC.TENMH
FROM MONHOC, LOP, GIANGDAY
WHERE LOP.MAGVCN = GIANGDAY.MAGV
	AND MONHOC.MAMH = GIANGDAY.MAMH
	AND GIANGDAY.HOCKY = 1
	AND GIANGDAY.NAM = 2006

/*
	8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So
Du Lieu”.
*/
SELECT (HO+' '+TEN) HOTEN
FROM HOCVIEN, LOP, GIAOVIEN, MONHOC, GIANGDAY
WHERE
	HOCVIEN.MAHV = LOP.TRGLOP
	AND GIANGDAY.MALOP = LOP.MALOP
	AND GIAOVIEN.HOTEN = N'Nguyen To Lan'
	AND MONHOC.TENMH = N'Cơ sở dữ liệu'
	AND GIANGDAY.MAGV = GIAOVIEN.MAGV
	AND GIANGDAY.MAMH = MONHOC.MAMH

/*
	9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So
Du Lieu”.
*/
SELECT MHT.MaMH, MHT.TENMH
FROM MONHOC, MONHOC AS MHT, DieuKien
WHERE MONHOC.MaMH = DieuKien.MaMH
	AND MHT.MaMH = DieuKien.MaMH_Truoc
	AND MONHOC.TENMH = 'Co So Du Lieu'

/*
	10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học,
tên môn học) nào.
*/
SELECT MONHOC.MaMH, MONHOC.TENMH
FROM MONHOC, MONHOC AS MHT, DieuKien
WHERE MONHOC.MaMH = DieuKien.MaMH
	 AND MHT.MaMH = DieuKien.MaMH_Truoc
	 AND MHT.TENMH = 'Cau Truc Roi Rac'

/*
	11. Tìm họ tên giáo viên dạy môn CTRR cHO cả hai lớp “K11” và “K12” trong cùng học kỳ 1
năm 2006.
*/
SELECT HOTEN
FROM GIAOVIEN, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND MALOP = 'K11'
	AND HOCKY = 1 AND Nam = 2006
INTERSECT (SELECT HOTEN
			FROM GIAOVIEN, GIANGDAY
			WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
				AND MALOP = 'K12' 
				AND HOCKY = 1 
				AND NAM = 2006)


/*
	12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng
chưa thi lại môn này.
*/
SELECT HOCVIEN.MAHV, (HO+' '+TEN) HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MaMH = 'CSDL' 
	AND LANTHI = 1 
	AND KQUA = 'Khong Dat'
	AND NOT EXISTS (SELECT * 
					FROM KETQUATHI 
					WHERE LANTHI > 1 
					AND KETQUATHI.MAHV = HOCVIEN.MAHV)

					
/*
	13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
*/
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT MAGV 
					FROM GIANGDAY)

/*
	14. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào
thuộc kHOa giáo viên đó phụ trách.
*/
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS(SELECT *
				FROM MONHOC
				WHERE MONHOC.MAKHOA = GIAOVIEN.MAKHOA
				AND NOT EXISTS(SELECT *
								FROM GIANGDAY
								WHERE GIANGDAY.MaMH = MONHOC.MaMH
								AND GIANGDAY.MAGV = GIAOVIEN.MAGV)
				)

/*
	15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong Dat”
HOặc thi lần thứ 2 môn CTRR được 5 điểm.
*/
SELECT DISTINCT (HO+' '+TEN) HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MALOP = 'K11'
	AND ((LANTHI = 2 AND DIEM = 5) OR HOCVIEN.MAHV IN(SELECT DISTINCT MAHV
														FROM KETQUATHI
														WHERE KQUA = 'Khong Dat'
														GROUP BY MAHV, MaMH
														HAVING COUNT(*) > 3)
		)
						

/*
	16. Tìm họ tên giáo viên dạy môn CTRR cHO ít nhất hai lớp trong cùng một học kỳ của một năm
học.
*/
SELECT HOTEN
FROM GIAOVIEN, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND MaMH = 'CTRR'
GROUP BY GIAOVIEN.MAGV, HOTEN, HOCKY
HAVING COUNT(*) >= 2


/*
	17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
*/
SELECT HOCVIEN.*, DIEM AS 'Điểm thi môn CSDL'
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MaMH = 'CSDL'
	AND LANTHI = (SELECT MAX(LANTHI) 
					FROM KETQUATHI 
					WHERE MaMH = 'CSDL' 
						AND KETQUATHI.MAHV = HOCVIEN.MAHV 
					GROUP BY MAHV)

/*
	18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần
thi).
*/
SELECT HOCVIEN.*, DIEM AS 'Điểm thi môn Cơ Sở Dữ liệu'
FROM HOCVIEN, KETQUATHI, MONHOC
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND KETQUATHI.MaMH = MONHOC.MaMH
	AND TENMH = 'Co So Du Lieu'
	AND DIEM = (SELECT MAX(DIEM) 
				FROM KETQUATHI, MONHOC
				WHERE KETQUATHI.MaMH = MONHOC.MaMH
					AND MAHV = HOCVIEN.MAHV
					AND TENMH = 'Co So Du Lieu'
				GROUP BY MAHV)


-------------------------------------BUOI 4---------------------------------------------------
/*
	19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
	BẢNG KHOA
	DỄ
*/
-- CACH 1
SELECT TOP 1 WITH TIES MAKHOA, TENKHOA
FROM KHOA
ORDER BY NGTLAP ASC

-- CACH 2
SELECT MAKHOA, TENKHOA
FROM KHOA
WHERE NGTLAP <= ALL(SELECT NGTLAP
					FROM KHOA)

/*
	20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”
	BẢNG GIAOVIEN
	DỄ
*/
SELECT HOCHAM, COUNT(HOCHAM) AS SLGV
FROM GIAOVIEN
WHERE HOCHAM = 'GS' OR HOCHAM = 'PGS'
GROUP BY HOCHAM

SELECT HOCHAM, COUNT(HOCHAM) AS SLGV
FROM GIAOVIEN
WHERE HOCHAM NOT IN ('GS', 'PGS')
GROUP BY HOCHAM

/*
	21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi
khoa.
*/
-- CACH 1
SELECT MAKHOA, HOCVI, COUNT(HOCVI) AS SOLUONG
FROM GIAOVIEN
WHERE HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
GROUP BY MAKHOA, HOCVI
ORDER BY MAKHOA

-- CACH 2
SELECT KHOA.MAKHOA, KHOA.TENKHOA, HOCVI, COUNT(HOCVI) AS SOLUONG
FROM GIAOVIEN, KHOA
WHERE GIAOVIEN.MAKHOA = KHOA.MAKHOA
	AND GIAOVIEN.HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
GROUP BY KHOA.MAKHOA, KHOA.TENKHOA, HOCVI
ORDER BY KHOA.MAKHOA

-- 1. Coi TS và PTS là giống nhau. Thống kê lại
-- Khó, rất khó

-- 2. Cập nhật PTS thành TS, TS thành TSKH
-- Update


UPDATE GIAOVIEN
SET HOCVI = 'TSKH'
WHERE HOCVI = 'TS'

UPDATE GIAOVIEN
SET HOCVI = 'TS'
WHERE HOCVI = 'PTS'

SELECT *
FROM GIAOVIEN

/*
[2:51 PM] Phạm Thế Sơn
'CN' : 15, 'KS' : 15, 'Ths' : 22, 'TS' : 30, 'TSKH' : 30
-- 'PGS' : 40, 'GS': 60
-- Tính chỉ tiêu tuyển sinh?
-- VỀ NHÀ

*/

/*
	22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
	Bảng: MONHOC, KETQUATHI
*/
SELECT MONHOC.MAMH, MONHOC.TENMH, KETQUATHI.KQUA, COUNT(DISTINCT KETQUATHI.MAHV) AS SOLUONG
FROM MONHOC, KETQUATHI
WHERE MONHOC.MAMH = KETQUATHI.MAMH
GROUP BY MONHOC.MAMH, MONHOC.TENMH, KETQUATHI.KQUA
ORDER BY MONHOC.MAMH

/*
	23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho
lớp đó ít nhất một môn học.
	BẢNG: GIAOVIEN, LOP, GIANGDAY
	KHÁ KHÓ
	DÙNG EXISTS (SUB QUERY)
*/
SELECT *
FROM GIAOVIEN
WHERE GIAOVIEN.MAGV IN (SELECT MAGVCN
						FROM LOP
						WHERE GIAOVIEN.MAGV = LOP.MAGVCN
							AND EXISTS (SELECT MAGV
										FROM GIANGDAY
										WHERE GIANGDAY.MAGV = LOP.MAGVCN)
						)
/*
	24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất
*/
SELECT (HOCVIEN.HO+' '+HOCVIEN.TEN) AS HOTEN
FROM HOCVIEN
WHERE MAHV IN (SELECT TRGLOP
						FROM LOP
						WHERE SISO = (SELECT MAX(SISO) FROM LOP)
						)
/*
	26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
	BANG: HOCVIEN, KETQUATHI
	BINH THUONG
*/
SELECT TOP 1 WITH TIES HOCVIEN.MAHV, (HO+' '+TEN) AS HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND KETQUATHI.DIEM >= 9
GROUP BY HOCVIEN.MAHV, HO, TEN
ORDER BY COUNT(*) DESC

/*
	27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
	BANG: LOP, HOCVIEN, KETQUATHI
	KHO
*/
SELECT A.MALOP, A.MAHV, A.HOTEN
FROM
(
	SELECT HOCVIEN.MAHV, MALOP, (HO+' '+TEN) HOTEN, COUNT(*) CNT
	FROM HOCVIEN, KETQUATHI
	WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
		AND DIEM IN(9, 10)
	GROUP BY MALOP, HOCVIEN.MAHV, HO, TEN
) AS A LEFT JOIN
(
	SELECT HOCVIEN.MAHV, MALOP, (HO+' '+TEN) HOTEN, COUNT(*) CNT
	FROM HOCVIEN, KETQUATHI
	WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
		AND DIEM IN(9, 10)
	GROUP BY MALOP, HOCVIEN.MAHV, HO, TEN
) AS B ON A.CNT < B.CNT AND A.MALOP = B.MALOP
WHERE B.CNT IS NULL

/*
	28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao
nhiêu lớp.
	BANG: GIAOVIEN
	DE
*/
SELECT COUNT(DISTINCT MAMH) AS SOMONHOC, COUNT(DISTINCT MALOP) AS SOLOP
FROM GIANGDAY
GROUP BY MAGV

/*
	29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
	BANG: GIANGDAY, GIAOVIEN
	KHO
*/
SELECT HOCKY, NAM, A.MAGV, HOTEN
FROM GIAOVIEN, (SELECT HOCKY, NAM, MAGV, RANK() OVER (PARTITION BY HOCKY, NAM
														ORDER BY COUNT(*) DESC) AS XEPHANG
				FROM GIANGDAY
				GROUP BY HOCKY, NAM, MAGV) AS A
WHERE A.MAGV = GIAOVIEN.MAGV
	AND XEPHANG = 1
ORDER BY NAM, HOCKY

/*
	30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1)
nhất
	BANG: MONHOC, KETQUATHI
	DE
*/
SELECT TOP 1 WITH TIES MONHOC.MAMH, TENMH
FROM MONHOC, KETQUATHI
WHERE MONHOC.MAMH = KETQUATHI.MAMH
	AND LANTHI = 1
	AND KQUA = 'Khong dat'
GROUP BY MONHOC.MAMH, TENMH
ORDER BY COUNT(*) DESC

/*
	31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
	BANG: HOCVIEN, KETQUATHI
	DE
*/
SELECT DISTINCT HOCVIEN.MAHV, (HO+' '+TEN) AS HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND NOT EXISTS
	(
		SELECT *
		FROM KETQUATHI
		WHERE LANTHI = 1
			AND KQUA = 'Khong dat'
			AND KETQUATHI.MAHV = HOCVIEN.MAHV
	)

/*
	32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
	BANG: HOCVIEN, KETQUATHI
	BINH THUONG
*/
SELECT DISTINCT HOCVIEN.MAHV, (HO+' '+TEN) HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND NOT EXISTS
	(
		SELECT *
		FROM KETQUATHI
		WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
			AND LANTHI =(
						SELECT MAX(LANTHI)
						FROM KETQUATHI
						WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
						GROUP BY MAHV
						)
			AND KQUA = 'Khong dat'
	)


-------------------------------------------- Buoi 5 ----------------------------------------------------
/*
	I5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
	Bảng: KETQUATHI
*/
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHECK_KQ CHECK((DIEM >= 5 AND KQUA = 'Dat') OR (DIEM < 5 AND KQUA = 'Khong dat'))

/*
	I6. Học viên thi một môn tối đa 3 lần.
	Bảng: KETQUATHI
*/
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHECK_SOLANTHI CHECK(LANTHI <= 3)

/*
	I7. Học kỳ chỉ có giá trị từ 1 đến 3.
	Bảng: GIANGDAY
*/
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHECK_HOCKY CHECK(HOCKY IN (1, 2, 3))

/*
	I8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
	Bảng: GIAOVIEN
*/
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_HOCVI CHECK(HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'))

/*
	I11. Học viên ít nhất là 18 tuổi.
	Bảng: HOCIVEN
*/
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHECK_TUOI CHECK(YEAR(GETDATE()) - YEAR(NGSINH) >= 18)

/*
	I12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc
(DENNGAY).
	BANG: GIANGDAY
*/
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHECK_NGAY CHECK(TUNGAY < DENNGAY)

/*
	I13. Giáo viên khi vào làm ít nhất là 22 tuổi.
	BANG: GIAOVIEN
*/
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_TUOIVL CHECK(YEAR(NGVL) - YEAR(NGSINH) >= 22)

/*
	I14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
	BANG: MONHOC
*/

ALTER TABLE MONHOC
ADD CONSTRAINT CHECK_TC CHECK(ABS(TCLT - TCTH) <= 3)


/*
	15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
	Bang: 
*/

-- Sao mấy câu trên dễ mà mấy câu sau khó quá :(((, em hổng biết làm

/*
	16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
	BANG: GIANGDAY
*/
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHECK_3MON CHECK()


/*
	17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó
*/


/*
	18. Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng
một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và
(“B”,”A”).
*/

/*
	19. Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau.
*/

/*
	20. Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5.
*/

/*
	21. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn
học).

*/

/*
	22. Học viên chỉ được thi những môn mà lớp của học viên đó đã học xong.
*/

/*
	23. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học (sau
khi học xong những môn học phải học trước mới được học những môn liền sau).
*/

/*
	24. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.
*/