clc 
clear
% 读文件，还可以改进，这种方法可扩展性太差


dir_name='f:\\fujian2\\';

%获取文件夹下的所有文件
fileFolder=fullfile(dir_name);
dirOutput=dir(fullfile(fileFolder,'*.bmp'));
fileNames={dirOutput.name};

left_index=0;
right_index=0;

imgsize_height=0;
imgsize_width=0;

count=size(fileNames,2);
dist=zeros(count,count);

%读取文件，并提取想要的信息
for index=1:count
    file_name=strcat(dir_name,fileNames{index});
    image=imread(file_name);
    
    if index==1
        %获取图片的高和宽
        [imgsize_height,imgsize_width]=size(image);
        
        %设置最大最小值用于后续比较
        max_begin_size=size(find(image(:,1)==255),1);
        max_end_size=size(find(image(:,end)==255),1);
        
        %初始化保存边缘的矩阵
        im_begin=zeros(size(image,1),size(fileNames,2));
        im_end=zeros(size(image,1),size(fileNames,2));
    
        
        im_begin(:,index)=image(:,1);
        im_end(:,index)=image(:,end);    
       
        continue;
    end
    
    %找到左端开始页碎片
    left_white=size(find(image(:,1)==255),1);
    if(max_begin_size<left_white)
        max_begin_size=left_white;
        left_index=index;
    end
    
    %找到右端开始页碎片
    right_white=size(find(image(:,end)==255),1);
    if(max_end_size<right_white)
        max_end_size=right_white;
        right_index=index;
    end
    
    im_begin(:,index)=image(:,1);
    im_end(:,index)=image(:,end);
end

%获取距离矩阵
for i=1:count
    for j=1:count
        if i~=j
            temp_i=im_end(:,i);
            temp_j=im_begin(:,j);
          
            dist(i,j)=pdist([temp_i';temp_j']);
        end
    end
end

%模拟退火解决TSP问题
[Solve_best,Cost_best]=TSP_SA_Func(dist,left_index,right_index);

%牛逼！！！！！！
disp(Solve_best);
disp(Cost_best);


total_image=zeros(imgsize_height,imgsize_width*count);

for index=1:count
    file_name=strcat(dir_name,fileNames{Solve_best(index)});
    image=imread(file_name);
    
    total_image(:,imgsize_width*(index-1)+1:imgsize_width*index)=image;
end


imshow(total_image);


imwrite(total_image,'d:\\image2.png');



