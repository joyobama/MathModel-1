clc 
clear
% ���ļ��������ԸĽ������ַ�������չ��̫��


dir_name='f:\\fujian2\\';

%��ȡ�ļ����µ������ļ�
fileFolder=fullfile(dir_name);
dirOutput=dir(fullfile(fileFolder,'*.bmp'));
fileNames={dirOutput.name};

left_index=0;
right_index=0;

imgsize_height=0;
imgsize_width=0;

count=size(fileNames,2);
dist=zeros(count,count);

%��ȡ�ļ�������ȡ��Ҫ����Ϣ
for index=1:count
    file_name=strcat(dir_name,fileNames{index});
    image=imread(file_name);
    
    if index==1
        %��ȡͼƬ�ĸߺͿ�
        [imgsize_height,imgsize_width]=size(image);
        
        %���������Сֵ���ں����Ƚ�
        max_begin_size=size(find(image(:,1)==255),1);
        max_end_size=size(find(image(:,end)==255),1);
        
        %��ʼ�������Ե�ľ���
        im_begin=zeros(size(image,1),size(fileNames,2));
        im_end=zeros(size(image,1),size(fileNames,2));
    
        
        im_begin(:,index)=image(:,1);
        im_end(:,index)=image(:,end);    
       
        continue;
    end
    
    %�ҵ���˿�ʼҳ��Ƭ
    left_white=size(find(image(:,1)==255),1);
    if(max_begin_size<left_white)
        max_begin_size=left_white;
        left_index=index;
    end
    
    %�ҵ��Ҷ˿�ʼҳ��Ƭ
    right_white=size(find(image(:,end)==255),1);
    if(max_end_size<right_white)
        max_end_size=right_white;
        right_index=index;
    end
    
    im_begin(:,index)=image(:,1);
    im_end(:,index)=image(:,end);
end

%��ȡ�������
for i=1:count
    for j=1:count
        if i~=j
            temp_i=im_end(:,i);
            temp_j=im_begin(:,j);
          
            dist(i,j)=pdist([temp_i';temp_j']);
        end
    end
end

%ģ���˻���TSP����
[Solve_best,Cost_best]=TSP_SA_Func(dist,left_index,right_index);

%ţ�ƣ�����������
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



