clc;
warning off;

%数据抓取
[sourcefile, status] = urlread('http://ris.szpl.gov.cn/credit/showcjgs/ysfcjgs.aspx?cjType=0'); %输入网址

if ~status
error('读取出错！\n')
end

%数据提取，可以通过补充代码提取更多信息。
expr1 = '\S*\d\d\d\d年\d\d月\d\d日\S*'; %获取日期           
datefile= regexp(sourcefile, expr1, 'match');
datefile=datefile{1,1};
date = datefile(end-10:end);
year=str2num(datefile(end-10:end-7));
month=str2num(datefile(end-5:end-4));
day=str2num(datefile(end-2:end-1));

 expr2 = '<td width="14%"><b>小计</b></td><td width="14%"><b>\d*</b>'; %获取成交套数
chengjiaoxiaoji = regexp(sourcefile, expr2, 'match');
chengjiaoxiaoji=chengjiaoxiaoji{1,1};
chengjiaoxiaoji=regexp(chengjiaoxiaoji,'>(\d*)</b>','tokens');


expr3='align="right"><b>\d*';
junjia = regexp(sourcefile, expr3, 'match');%获取成交均价
junjia=junjia{1,2};
junjia=regexp(junjia,'<b>(\d*)','tokens');


expr4='<td width="14%">\d*';%获取可售套数
keshou=regexp(sourcefile, expr4, 'match');
keshou=keshou{1,45};
keshou=regexp(keshou,'">(\d*)','tokens');

%保存数据到Excel
filename = sprintf('%d年深圳商品房信息.xls',year);
pathname = [pwd '\data'];

if ~exist(pathname,'dir')  
mkdir(pathname);
end

filepath = [pwd '\data\' filename];
sheet = sprintf('%d年深圳商品房信息', year);

if ~exist(filepath,'file')%判断路径下是否存在文件，如果不存在创建新文件
    head={'日期','成交套数','成交均价(元)','可售套数'};
    xlswrite(filepath,head,sheet);
end

[a,b,i]=xlsread(filepath,sheet);%filepath为x.xls文件路径
range = sprintf('A%d',size(i,1)+1);%判断路径下已存在文件的行数，在下一行追加新数据。
shuju= {date,cell2mat(chengjiaoxiaoji{1,1}),cell2mat(junjia{1,1}),cell2mat(keshou{1,1})};%将cell格式数据提取出来，转化为mat格式，构建新cell写入excel文件。
xlswrite(filepath, shuju,sheet,range);
helpdlg('数据获取成功!')
edittext=sprintf('新增信息：%d年%d月%d日,均价%d',year,month,day,str2double(junjia{1,1}));