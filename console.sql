#（1）编写并运行SQL语句，创建数据库EstateDB。
create database estatedb;


#（2）编写并运行SQL语句，在数据库EstateDB中创建上述3个数据库表，并定义其完整性约束。
create table Owner(
    PersonID char(18) primary key not null,
    Name varchar(20) not null,
    Gender char(2) not null,
    Occupation varchar(20) not null,
    Addr varchar(50) not null,
    Tel varchar(11) not null
);

create table Estate(
    EstateID char(15) primary key not null,
    EstateName varchar(50) not null,
    EstateBuildName varchar(50) not null,
    EstateAddr varchar(60) not null,
    EstateCity varchar(60) not null,
    EstateType enum('住宅','商铺','车位','别墅') not null,
    PropertyArea numeric(5,2) not null,
    UsableArea numeric(5,2) not null,
    CompleteDate date not null,
    YearLength int default '70' not null,
    Remark varchar(100)
);

create table Registration(
    RegisterID int primary key not null,
    PersonID char(18) not null,
    EstateID char(15) not null,
    Price decimal(10,2) not null,
    PurchasedDate date not null,
    DeliverDate date not null
);

alter table Registration add constraint sfzh foreign key (PersonID) references Owner(PersonID);
alter table Registration add constraint fcbn foreign key (EstateID) references Estate(EstateID);


#（3）准备样本数据， 编写并运行SQL语句，在上述3个数据库表中添加数据。
# 该步操作正常应该使用insert语句，但实际使用excel另存为csv格式进行插入表
#

#（4）编写并运行SQL语句，查询类别为“商铺” 的房产信息。
select * from estate where EstateType = '商铺';


#（5）编写并运行SQL语句，查询竣工日期为2018年12月1日后， 产权面积90平方米以上的“住宅” 的房产信息。
select * from estate where EstateType = '住宅' and CompletedDate > '2018-12-01' and PropertyArea > 90;


# 6）编写并运行SQL语句，查询个人在各地购买住宅两套以上的业主基本信息。
select o.*,count(r.PersonID) from Owner as o join Registration as r on o.PersonID = r.PersonID join Estate as e on e.EstateID = r.EstateID
where e.EstateType = '住宅'
group by o.PersonID,o.Name,o.Gender,o.Occupation,o.Addr,o.Tel
having count(*)>2;


#（7）编写并运行SQL语句，查询个人在特定城市购买住宅两套以上的业主基本信息。
select o.*,count(r.PersonID) from Owner as o join Registration as r on o.PersonID = r.PersonID join Estate as e on e.EstateID = r.EstateID
where e.EstateType = '住宅' and e.EstateCity = '大庆'
group by o.PersonID,o.Name,o.Gender,o.Occupation,o.Addr,o.Tel
having count(*)>2;


#（8）编写并运行SQL语句，统计2018年度某城市的各类房产销售面积。
select e.EstateCity,e.EstateType,sum(e.PropertyArea) from Estate as e join Registration as r on e.EstateID = r.EstateID
where EstateCity = '大庆' and r.PurchasedDate between 2018-01-01 and 2018-12-31
group by e.EstateType;


#（9）编写并运行SQL语句，统计2018年度某城市的各类房产销售金额。
select e.EstateCity,e.EstateType,sum(r.Price) from Estate as e join Registration as r on e.EstateID = r.EstateID
where EstateCity = '大庆' and r.PurchasedDate between 2018-01-01 and 2018-12-31
group by e.EstateType;


#（10）创建SQL视图，通过视图查询指定身份证号下，该业主的购置房产信息（房产编号、房产名称、房产类型、产权面积、购买金额、购买日期、房产楼盘、房产城市），并按日期降序排列。
create view Information as select o.PersonID,e.EstateID,e.EstateName,e.EstateBuildName,e.EstateCity,e.EstateType,e.PropertyArea,r.Price,r.PurchasedDate
from Estate as e join Registration as r on e.EstateID = r.EstateID join Owner as o on r.PersonID = o.PersonID
order by r.PurchasedDate desc;

select * from information where PersonID = '230602197203246788';


# （11）创建SQL视图，分组统计2018年度各城市的住宅销售套数与总销售金额。
create view Sale as select e.EstateID,e.EstateCity,e.EstateType,r.Price,r.PurchasedDate,count(e.EstateID),sum(r.Price)
from Estate as e join Registration as r on e.EstateID = r.EstateID
where e.EstateCity = '住宅' and r.PurchasedDate between 2018-01-01 and 2018-12-31
group by e.EstateCity


