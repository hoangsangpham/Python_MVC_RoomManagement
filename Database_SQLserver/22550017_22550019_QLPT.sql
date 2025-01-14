﻿/*
Họ và tên: Đào Nhâm Phúc
MSSV: 22550017
Họ và tên: Phạm Hoàng Sang
MSSV: 22550019
*/

-- Tạo cơ sở dữ liệu quản lý phòng trọ
CREATE DATABASE QLPT

USE QLPT

/* Chuyển về định dạng ngày - tháng - năm */
SET DATEFORMAT DMY

--Tạo bảng Users
CREATE TABLE USERS
(
	username CHAR(255) NOT NULL PRIMARY KEY,
	password NVARCHAR(255)
)

INSERT INTO USERS (username, password) VALUES ('admin','123')
INSERT INTO USERS (username, password) VALUES ('phuc','123')
INSERT INTO USERS (username, password) VALUES ('sang','123')


--Tạo bảng khách hàng
CREATE TABLE KHACHHANG
(
	MAKH CHAR(10) NOT NULL PRIMARY KEY,
	TENKH NVARCHAR(255),
	CMND_CCCD VARCHAR(255),
	NGSINH DATE,
	GIOITINH NVARCHAR(5),
	SDT VARCHAR(255),
	DCHI NVARCHAR(255),
	NGNGHIEP NVARCHAR(255)
)
--Tạo bảng phòng trọ
CREATE TABLE PHONGTRO
(
	MAPT CHAR(10) NOT NULL PRIMARY KEY,
	TENPT NVARCHAR(255),
	TINHTRANG NVARCHAR(255),
	DCHIPT NVARCHAR(255),
	GIA MONEY
)
--Tạo bảng dịch vụ
CREATE TABLE DICHVU
(
	MADV CHAR(10) NOT NULL PRIMARY KEY,
	TENDV NVARCHAR(255),
	GIA MONEY
)
--Tạo bảng phiếu đăng ký
CREATE TABLE PHIEUDK
(
	MAPDK CHAR(10) NOT NULL PRIMARY KEY,
	MAKH CHAR(10) NOT NULL FOREIGN KEY REFERENCES KHACHHANG(MAKH),
	MAPT CHAR(10) NOT NULL FOREIGN KEY REFERENCES PHONGTRO(MAPT),
	NGTHUE DATE,
	NGTRA DATE
)
--Tạo bảng chi tiết dịch vụ
CREATE TABLE CTDV
(
	MAPDK CHAR(10) NOT NULL FOREIGN KEY REFERENCES PHIEUDK(MAPDK),
	MADV CHAR(10) NOT NULL FOREIGN KEY REFERENCES DICHVU(MADV),
	TUNGAY DATE,
	DENNGAY DATE,
	SC FLOAT,
	SM FLOAT
	/*PRIMARY KEY (MAPDK, MADV)*/
)
--Tạo bảng hóa đơn
CREATE TABLE PHIEUTHANHTOAN
(
	MAPTT CHAR(10) NOT NULL PRIMARY KEY,
	MAPDK CHAR(10) NOT NULL FOREIGN KEY REFERENCES PHIEUDK(MAPDK),
	NGTT DATE,
	SOTHANG INT,
	TONGTIEN MONEY
)

--Tạo thêm các ràng buộc nếu có
/* Ràng buộc tồn tại duy nhất */
-- Chứng minh nhân dân hoặc căn cước công dân (CMND_CCCD) của mỗi khách hàng là duy nhất” cho quan hệ KHACHHANG
ALTER TABLE KHACHHANG ADD CONSTRAINT UQ_KHACHHANG_CMND_CCCD UNIQUE (CMND_CCCD)

/* Ràng buộc kiểm tra điều kiện */
-- Giới tính (GIOITINH) của khách hàng phải là Nam hoặc Nữ
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_KHACHHANG_GIOITINH CHECK (GIOITINH IN ('Nam', N'Nữ'))

-- Giá (GIA) phòng trọ phải lớn hơn hoặc bằng 0
ALTER TABLE PHONGTRO ADD CONSTRAINT CK_PHONGTRO_GIA CHECK (GIA >= 0)

-- Tình trạng phòng trọ (TINHTRANG) chỉ được là 'Đã ở', 'Còn trống' và 'Đang sửa chữa'
ALTER TABLE PHONGTRO ADD CONSTRAINT CK_PHONGTRO_TINHTRANG CHECK (TINHTRANG IN (N'Đã ở', N'Còn trống', N'Đang sửa chữa'))

-- Số tháng (SOTHANG) trong bảng phiếu thanh toán phải bé lớn hoặc bằng 1 và bé hơn hoặc bằng 12
ALTER TABLE PHIEUTHANHTOAN ADD CONSTRAINT CK_CTDV_SOTHANG CHECK (SOTHANG >= 1 AND SOTHANG <= 12)

-- Tổng tiền (TONGTIEN) trong bảng phiếu thanh toán phải lớn hơn hoặc bằng 0
ALTER TABLE PHIEUTHANHTOAN ADD CONSTRAINT CK_CTDV_TONGTIEN CHECK (TONGTIEN >=0)
