-- tao database
create database QuanLyCaPhe
go
use QuanLyCaPhe
go
																									--CREATE TABLE--
-- tao bang thong tin nhan vien
create table ThongTinNhanVien
(
	MaNhanVien char(10) primary key not null,
	TenNhanVien nvarchar(50) not null default N'Tên',
	NgaySinh date,
	ChucVu nvarchar(50) not null default N'Chức Vụ'	
)
go
-- tao ban loai tai khoan
create table LoaiTaiKhoan
(
	MaLoaiTK int  not null  primary key,
	KieuTK nvarchar(50)  not null
)
go
-- tai ban tai khoan
create table TaiKhoan
(
	TenDangNhap nvarchar(50) primary key not null,
	MatKhau varchar(500) not null ,	
	MaLoaiTK int not null

	foreign key (MaLoaiTK) references LoaiTaiKhoan(MaLoaiTK),
)
go
-- tao bang loai san pham
create table LoaiSanPham
(
	MaLoaiSP int identity not null primary key,
	TenLoaiSP nvarchar(100)  not null
)
go
-- tao bang san pham
create table SanPham
(
	MaSanPham int identity not null primary key,
	TenSanPham nvarchar(100)  not null,
	LoaiSanPham int not null,
	GiaSanPham int not null default 0

	foreign key (LoaiSanPham) references LoaiSanPham(MaLoaiSP)
)
go
-- tao bang ban
create table Ban
(
	MaBan int identity primary key,
	TenBan nvarchar(20) not null default N'Chưa đặt tên',
	TrangThaiBan nvarchar(10)  not null default N'Trống'
)
go
-- tao bang hoa don
create table HoaDon
(
	MaHoaDon int identity not null primary key,
	NgayVao Date not null default GETDATE(),--14/12/2021	
	NgayRa Date not null default GETDATE(),--14/12/2021
	MaBan int not null,
	GiamGia int not null default 0,
	TrangThaiHD int not null default 0 ,-- 1: Da thanh toan, 0: Chua thanh toan
	TongTien float
	foreign key (MaBan) references Ban(MaBan)
)
go
-- tao bang thong tin hoa don
create table ThongTinHoaDon
(
	MaTTHoaDon int identity not null primary key ,
	MaHoaDon int not null ,
	MaSanPham int not null,
	SoLuong int not null default 0

	foreign key (MaHoaDon) references HoaDon(MaHoaDon),
	foreign key (MaSanPham) references SanPham(MaSanPham)
)
go

																									--NHÂN VIÊN--																											
--CÁC CHỨC NĂNG	NHÂN VIÊN--
--Thêm nhân viên
CREATE PROC sp_ThemNhanVien(@ma char(10), @ten nvarchar(50), @ngaysinh date, @chucvu nvarchar(50))
as
begin
insert into ThongTinNhanVien(MaNhanVien,TenNhanVien,NgaySinh,ChucVu)
values(@ma,@ten, @ngaysinh, @chucvu)
End
GO

--Xóa nhân viên-
create proc sp_Xoanhanvien(@ma char(10))
as
begin
delete from ThongTinNhanVien
where MaNhanVien = @ma
end
go

--Sửa nhân viên--
create proc sp_SuaNhanVien(@ma char(10), @ten nvarchar(50), @ngaysinh date, @chucvu nvarchar(50))
as
begin
update ThongTinNhanVien
set TenNhanVien= @ten,
NgaySinh = @ngaysinh,
ChucVu =@chucvu
where MaNhanVien = @ma
end
go

--tim nhân viên--
create proc sp_TimNhanVien(@ma char(10))
as
begin
select * from ThongTinNhanVien
where MaNhanVien = @ma
end
go

--Hiện thị toàn bộ danh sách nhân viên--
create proc sp_LayDanhSachNhanVien
as
begin
select * from ThongTinNhanVien
end
go


--THỰC HIỆN--
--Thêm nhân viên--
exec sp_ThemNhanVien 'ql01' , N'Nguyễn Thư','06/02/1991', N'Quant lý'
exec sp_ThemNhanVien 'nv01' , N'Blue Pearl','12/12/1991', N'Nhân viên'
exec sp_ThemNhanVien 'nv02' , N'Tunnie','08/05/1991', N'Nhân viên'

--Xóa nhân viên--
exec sp_Xoanhanvien 'nv02'

--Sửa nhân viên--
exec sp_SuaNhanVien 'nv02' , N'Tunnie','07/06/1991', N'Nhân viên'

--Lấy danh sách nhân viên
exec sp_LayDanhSachNhanVien
go

																									--BÀN--
--CÁC CHỨC NĂNG	BÀN--
--Tạo danh sách bàn--
declare @i int = 1
while @i <= 28
begin
	insert into Ban(TenBan)
	values (N'Bàn ' + CAST(@i as nvarchar(20)))
	set @i = @i + 1
end
go

--Lấy danh sách bàn--
create proc sp_LayDanhSachBan
as
begin
select * from Ban
end
go

--THỰC HIỆN--
--Lấy danh sách bàn--
exec sp_LayDanhSachBan
go

																									--HÓA ĐƠN--

--CÁC CHỨC NĂNG	HÓA ĐƠN--
--lấy danh sách hóa đơn--
create proc sp_LayDanhSachHoaDon
as
begin
select MaBan, TongTien, NgayVao, GiamGia
from HoaDon
end
go

--Thêm hóa đơn--
CREATE PROC sp_ThemHoaDon(@maban int, @tongtien float, @ngayvao date,@ngayra date, @giamgia int)
as
begin
insert into HoaDon(MaBan, TongTien, NgayVao,NgayRa,GiamGia)
values(@maban, @tongtien, @ngayvao,@ngayra, @giamgia)
End
GO

--THỰC HIỆN--
--Thêm hóa đơn--
exec sp_ThemHoaDon 2, 150000, '12/14/2021','12/14/2021', 0
exec sp_ThemHoaDon 5, 160000, '12/14/2021','12/14/2021', 0
exec sp_ThemHoaDon 9, 200000, '12/14/2021','12/14/2021', 0
exec sp_ThemHoaDon 9, 200000, '12/05/2021','12/05/2021', 0
exec sp_ThemHoaDon 9, 200000, '12/31/2021','12/31/2021', 0
exec sp_ThemHoaDon 9, 200000, '11/12/2021','11/12/2021', 0

--lấy toàn bộ hóa đơn--
exec sp_LayDanhSachHoaDon
																														--THỐNG KÊ--
--Hàm thống kê--
select MaBan, TongTien, NgayVao, GiamGia from HoaDon where NgayVao >= '12/01/2021 ' AND NgayRa <= '12/15/2021'
go

--Hàm thống kê--
CREATE PROC sp_ThongKe(@ngaybd date, @ngaykt date)
as
begin
select MaBan as [Mã Bàn], TongTien as [Tổng tiền], NgayVao as [Ngày vào], GiamGia as [Giảm giá] from HoaDon 
where NgayVao >= @ngaybd AND NgayRa <= @ngaykt
End
GO

exec sp_ThongKe '12/14/2021', '12/31/2021'
GO

																									--LOẠI TÀI KHOẢN--
--CÁC CHỨC NĂNG LOẠI TÀI KHOẢN--
-- Thêm loại tài khoản
CREATE PROC sp_ThemLoaiTaiKhoan(@maloaiTK int,  @kieuTK varchar(50))
as
begin
insert into LoaiTaiKhoan(MaLoaiTK,KieuTK)
values(@maloaiTK ,@kieuTK)
End
GO
-- Lấy tất cả loại tài khoản (admin, nhân viên)
create proc sp_LayDanhSachLoaiTaiKhoan
as
begin
select * from LoaiTaiKhoan
end
go

--THỰC HIỆN--
--Thêm loại tài khoản-- 
exec sp_ThemLoaiTaiKhoan 1,'nhan vien'
exec sp_ThemLoaiTaiKhoan 0,'admin'
--Lấy danh sách tài khoản-- 
exec sp_LayDanhSachLoaiTaiKhoan
go

--THÊM TÀI KHOẢN ĐỂ CHẠY ĐĂNG NHẬP--
INSERT INTO TaiKhoan(TenDangNhap,MatKhau,MaLoaiTK)
VALUES ('vinguyen','123',1),
		('nguyenthu','123',1),
		('ngocyen','123',1),
		('admin','admin',0)
go																									--ĐĂNG NHẬP--

--Hàm đăng nhập--
CREATE PROC sp_DangNhap(@tenDangNhap nvarchar(50), @pass varchar(500))
AS
BEGIN
	SELECT *
	FROM dbo.TaiKhoan
	WHERE TenDangNhap = @tenDangNhap AND MatKhau = @pass
End
GO

--THỰC HIỆN--
--Thực thi chức năng đăng nhập
exec sp_DangNhap N'admin','admin'
go

																									--LOẠI SẢN PHẨM--

--CÁC CHỨC NĂNG LOẠI SẢN PHẨM--
-- Thêm loại sản phẩm
CREATE PROC sp_ThemLoaiSanPham(@ten nvarchar(100))
as
begin
insert into LoaiSanPham(TenLoaiSP)
values(@ten)
End
GO

--Xóa loại sản phẩm--
create proc sp_XoaLoaiSanPham(@maLoaiSanPham int)
as
begin
delete from LoaiSanPham
where MaLoaiSP = @maLoaiSanPham
end
go

--Sửa loại sản phẩm--
create proc sp_SuaLoaiSanPham(@maLoaiSanPham int, @tenLoaiSanPham nvarchar (100))
as
begin
update LoaiSanPham
set TenLoaiSP = @tenLoaiSanPham
where MaLoaiSP = @maLoaiSanPham
end
go

--Hàm láy tên gần giống nhất, không dấu hoặc có dấu
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
go

--Tim loai sản phẩm theo tên
create proc sp_TimTenLoaiSP(@tenLoai nvarchar (100))
as
begin
select * from LoaiSanPham
where dbo.fuConvertToUnsign1(TenLoaiSP) like N'%'+ @tenLoai + N'%'
end
go

--Lấy danh sách loại sản phẩm
create proc sp_LayDanhSachLoai
as
begin
select * from LoaiSanPham
end
go

--THỰC HIỆN--
--Thêm loại
exec sp_ThemLoaiSanPham N'Cà phê'
exec sp_ThemLoaiSanPham N'Ăn vặt'
exec sp_ThemLoaiSanPham N'Nước giải khát'
exec sp_ThemLoaiSanPham N'Thức uống có ga'
exec sp_ThemLoaiSanPham N'Nước ép trái cây'
exec sp_ThemLoaiSanPham N'Trà sữa'


--Sửa loại sản phẩm
exec sp_SuaLoaiSanPham 1,'Coffe'

--Tìm loại sản phẩm theo tên
exec sp_TimTenLoaiSP N'%nu%'

--Xuất toàn bộ danh sách loai sản phẩm
exec sp_LayDanhSachLoai
go

																									--SẢN PHẨM--

--CÁC CHỨC NĂNG CỦA SẢN PHẨM--
--Thêm sản phẩm
CREATE PROC sp_ThemSanPham(@tenSanPham nvarchar(100), @loaiSanPham int, @gia int)
as
begin
insert into SanPham(TenSanPham, LoaiSanPham,GiaSanPham)
values(@tenSanPham, @loaiSanPham, @gia)
End
GO

--Xóa sản phẩm--
create proc sp_XoaSanPham(@maSanPham int)
as
begin
delete from SanPham
where MaSanPham = @maSanPham
end
go

--Sửa sản phẩm--
create proc sp_SuaSanPham(@maSanPham int, @tenSanPham nvarchar (100), @LoaiSanPham int, @GiaSanPham int)
as
begin
update SanPham
set TenSanPham = @tenSanPham,
	LoaiSanPham = @LoaiSanPham,
	GiaSanPham = @GiaSanPham
where MaSanPham = @maSanPham
end
go

--Lấy danh sách sản phẩm--
create proc sp_LayDanhSachSanPham
as
begin
select SanPham.MaSanPham, SanPham.TenSanPham, LoaiSanPham.TenLoaiSP, SanPham.GiaSanPham 
from SanPham inner join LoaiSanPham
on SanPham.LoaiSanPham = LoaiSanPham.MaLoaiSP
end
go

--Lấy tên gần giống nhất
create proc sp_TimTenSP(@ten nvarchar(100))
as
begin
select * from SanPham
where dbo.fuConvertToUnsign1(TenSanPham) like N'%'+ @ten + N'%'
end
go


--THỰC HIỆN--
--Thực thi các chức năng sản phẩm
exec sp_ThemSanPham N'Cà phê đá', 1, 10000
exec sp_ThemSanPham N'Cà phê sữa', 1, 12000
exec sp_ThemSanPham N'Cà phê fin (đen)', 1, 8000
exec sp_ThemSanPham N'Cà phê fin (sữa)', 1, 10000
exec sp_ThemSanPham N'Bánh tráng trộn', 2, 25000
exec sp_ThemSanPham N'Sushi', 2, 15000
exec sp_ThemSanPham N'Bò viên chiên', 2, 10000
exec sp_ThemSanPham N'Xúc xích chiên', 2, 10000
exec sp_ThemSanPham N'Ốc nhồi chiên', 2, 12000
exec sp_ThemSanPham N'Há cảo chiên', 2, 15000
exec sp_ThemSanPham N'7up', 3, 16000
exec sp_ThemSanPham N'Sữa tươi', 3, 16000
exec sp_ThemSanPham N'Nước ép cam', 4, 14000
exec sp_ThemSanPham N'Dâu dằm', 4, 10000
exec sp_ThemSanPham N'Trà sữa truyền thống', 5, 18000
exec sp_ThemSanPham N'Trà sữa Chocolate', 5, 22000
exec sp_ThemSanPham N'Trà sữa Matcha', 5, 20000
exec sp_ThemSanPham N'Trà sữa Việt quất', 5, 24000
exec sp_ThemSanPham N'Capuchino', 5, 25000
exec sp_ThemSanPham N'Macchiato', 5, 25000


--Xuất toàn bộ danh sách loai sản phẩm
exec sp_LayDanhSachSanPham

--Tìm sản phẩm theo tên
exec sp_TimTenSP N'%ca%'
go

																									--YẾN--
																									--TÀI KHOẢN--
--CÁC CHỨC NĂNG CỦA TÀI KHOẢN--
-- Thêm tài khoản--
CREATE PROC sp_ThemTaiKhoan(@tenDangNhap nvarchar(50),  @pass varchar(500), @maLoaiTK int)
as
begin
insert into TaiKhoan(TenDangNhap, MatKhau, MaLoaiTK)
values(@tenDangNhap, @pass, @maLoaiTK)
End
go

-- Xóa tài khoản--
create proc sp_XoaTaiToan(@tenDangNhap nvarchar(50))
as
begin
delete from TaiKhoan
where TenDangNhap = @tenDangNhap
end
go

-- Sửa tài khoản--
create proc sp_SuaTaiKhoan(@tenDangNhap nvarchar(50),  @pass varchar(500), @maLoaiTK int)
as
begin
update TaiKhoan
set MatKhau = @pass, 
MaLoaiTK = @maLoaiTK
where TenDangNhap = @tenDangNhap
end
go

-- Tìm kiếm tài khoản
create proc sp_TimTaiKhoan(@tenDangNhap nvarchar(50))
as
begin
select * from TaiKhoan
where TenDangNhap = @tenDangNhap
end
go

-- Lấy danh sách tài khoản
create proc sp_LayDanhSachTaiKhoan
as
begin
select * from TaiKhoan
end
go

--THỰC HIỆN--
-- Thêm tìa khoản--
exec sp_ThemTaiKhoan 'khanhvi','123',1
exec sp_ThemTaiKhoan 'nguyenthu','123',1
exec sp_ThemTaiKhoan 'yentnn','0212',1
exec sp_ThemTaiKhoan 'admin','admin',0
exec sp_ThemTaiKhoan 'abc','123',1



-- Lấy danh sách tài khoản--
exec sp_LayDanhSachTaiKhoan
go
	-- Tao danh sach ban
declare @i int = 1
while @i <= 25
begin
	insert into Ban(TenBan)
	values (N'Bàn ' + CAST(@i as nvarchar(20)))
	set @i = @i + 1
end
go
-- xoa ban
create proc sp_XoaBan(@tenBan nvarchar(20))
as
begin
delete from Ban
where TenBan = @tenBan
end
go
-- done

-- tim ban
create proc sp_TimBan(@tenBan nvarchar(20))
as
begin
select * from Ban
where TenBan = @tenBan
end
go
-- done
-- hien thi toan bo danh sach ban

create proc sp_ThemVaoHoaDon (@maBan int)
as
begin
insert into HoaDon (NgayVao,MaBan,GiamGia,TrangThaiHD)
values (GETDATE(),@maBan,0,0)
end
--done
-- them tt hoa don
create proc sp_ThemTTHoaDon(@maHD int, @maSP int, @soLuong int)
as
begin
insert into ThongTinHoaDon (MaHoaDon,MaSanPham,SoLuong)
values (@maHD,@maSP,@soLuong)
end
--
CREATE PROC sp_InsertThTHoaDon
@maHD INT, @maSP INT, @soLuong INT
AS
BEGIN

	DECLARE @isExitsTTHD INT;
	DECLARE @soLuongC INT = 1-- so luong dua vao 
	
	SELECT @isExitsTTHD = MaTTHoaDon, @soLuongC = b.SoLuong 
	FROM ThongTinHoaDon AS b 
	WHERE MaHoaDon = @maHD AND MaSanPham = @maSP

	IF (@isExitsTTHD > 0)
	BEGIN
		DECLARE @newCount INT = @soLuongC + @soLuong
		IF (@newCount > 0)
			UPDATE ThongTinHoaDon	SET SoLuong = @soLuongC + @soLuong WHERE MaSanPham = @maSP
		ELSE
			DELETE ThongTinHoaDon WHERE MaHoaDon = @maHD AND MaSanPham = @maSP
	END
	ELSE
	BEGIN
		INSERT	ThongTinHoaDon
        ( MaHoaDon, MaSanPham, SoLuong )
		VALUES  ( @maHD, -- idBill - int
          @maSP, -- idFood - int
          @soLuong  -- count - int
          )
	END
END
GO
create trigger tg_UpdateTTHD
on ThongTinHoaDon
for insert, update
as
begin
declare @maHD int
select @maHD = MaHoaDon from inserted
declare @maBan int 
select @maBan =MaBan from HoaDon where MaHoaDon = @maHD and TrangThaiHD = 0
update Ban set TrangThaiBan = N'Có người' where MaBan = @maBan
end
go
create trigger tg_UpdateHD
on HoaDon
for update
as
begin
declare @maHD int
select @maHD = MaHoaDon from inserted

declare @maBan int 
select @maBan =MaBan from HoaDon where MaHoaDon = @maHD 
declare @soLuong int = 0
select @soLuong =COUNT(*)  from HoaDon where MaBan = @maBan and TrangThaiHD =0
if (@soLuong = 0)
update Ban set TrangThaiBan= N'Trống' where MaBan = @maBan
end
go
																								--BÀN--
create proc sp_GetListBillByDate
@ngayVao date , @ngayRa date
as
begin
select b.TenBan as[Tên bàn],h.TongTien as[Tổng tiền], NgayVao as [Ngày vào],NgayRa as[Ngày Ra],GiamGia as[Giảm giá]
 from HoaDon as h, Ban as b
where NgayVao >= @ngayVao 
and NgayRa <= @ngayRa
and h.TrangThaiHD=1 
and b.MaBan =  h.MaBan
end
go
