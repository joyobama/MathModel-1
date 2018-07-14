clc;clear;

%T(n+1)=a*T(n) ?
a=0.99;

%��ĳһ�¶�T�´ﵽ���������Ч��
Markov_length=10000;

%��ʼ�¶�
t0=97;tf=3;t=t0;

% �������ݣ��Ժ�����װ��������
coordinates = [
1	 565.0	 575.0;	
2	  25.0	 185.0;	
3	 345.0	 750.0;	
4	 945.0	 685.0;	
5	 845.0	 655.0;	
6	 880.0	 660.0;	
7	  25.0	 230.0;	
8	 525.0	1000.0;	
9	 580.0	1175.0;	
10	 650.0	1130.0;	
11	1605.0	 620.0;	
12	1220.0	 580.0;	
13	1465.0	 200.0;	
14	1530.0	   5.0;	
15	 845.0	 680.0;	
16	 725.0	 370.0;	
17	 145.0	 665.0;	
18	 415.0	 635.0;	
19	 510.0	 875.0;	
20	 560.0	 365.0;	
21	 300.0	 465.0;	
22	 520.0	 585.0;	
23	 480.0	 415.0;	
24	 835.0	 625.0;	
25	 975.0	 580.0;	
26	1215.0	 245.0;	
27	1320.0	 315.0;	
28	1250.0	 400.0;	
29	 660.0	 180.0;	
30	 410.0	 250.0;	
31	 420.0	 555.0;	
32	 575.0	 665.0;	
33	1150.0	1160.0;	
34	 700.0	 580.0;	
35	 685.0	 595.0;	
36	 685.0	 610.0;	
37	 770.0	 610.0;	
38	 795.0	 645.0;	
39	 720.0	 635.0;	
40	 760.0	 650.0;	
41	 475.0	 960.0;	
42	  95.0	 260.0;	
43	 875.0	 920.0;	
44	 700.0	 500.0;	
45	 555.0	 815.0;	
46	 830.0	 485.0;	
47	1170.0	  65.0;	
48	 830.0	 610.0;	
49	 605.0	 625.0;	
50	 595.0	 360.0;	
51	1340.0	 725.0;	
52	1740.0	 245.0;	
];

%�����ݴ����ֻʣ����
coordinates(:,1)=[];

%������е�ĸ�����size��һ����������rows
count=size(coordinates,1);

%����������
dist_temp_x1=coordinates(:,1)*ones(1,count);
dist_temp_x2=dist_temp_x1';

dist_temp_y1=coordinates(:,2)*ones(1,count);
dist_temp_y2=dist_temp_y1';

%���ɾ������
dist_martix=sqrt((dist_temp_x1-dist_temp_x2).^2+(dist_temp_y1-dist_temp_y2).^2);

%��ʼ��
solve0=1:count;

%��ʼ������
Cost_current=inf;
Cost_best=inf;
Cost_new=inf;

Solve_new=solve0;
Solve_current=solve0;
Solve_best=solve0;

%�Ŷ�����
rand_rao_dong=0.5;

%��ʼģ���˻����
while t>=tf
    
    %ÿ���˻���̽���Markov��Ϊ��Ѱ�ҵ���ǰ�¶�����õĽ�
    for r=1:Markov_length
        
        %����Ŷ���������������������
        if(rand<rand_rao_dong)
           %������
           rand1=0;rand2=0;
           
           %Ϊ�˲�������ͬ�������
           while rand1==rand2
               rand1=ceil(rand.*count);
               rand2=ceil(rand.*count);
           end
           
           temp=Solve_new(rand1);
           Solve_new(rand1)=Solve_new(rand2);
           Solve_new(rand2)=temp;
           
        else
           %�������� ��ѡ���v1��v2��v3,��v1��v2֮���·�����뵽v3֮��
           rand1=0;rand2=0;rand3=0;
           
           
           % ���һ��������Ϊ������v1,v2֮��û��Ԫ�ص�״���Լ���������������
           while (rand1==rand2 || rand1==rand3 || rand2==rand3 || abs(rand2-rand1)==1) || ~(rand1<rand3 && rand1<rand2 && rand2<rand3)  
               rand1=ceil(rand.*count);
               rand2=ceil(rand.*count);
               rand3=ceil(rand.*count);
           end
           
           %ע������//matlab������û��python���
           temp=Solve_new((rand1+1):(rand2-1));
           Solve_new((rand1+1):(rand1+rand3-rand2+1))=Solve_new(rand2:rand3);
           Solve_new((rand1+rand3-rand2+2):rand3)=temp;
           
        end
        
        %����Cost
        Cost_new=0;
        for i=1:(count-1)
            Cost_new=Cost_new+dist_martix(Solve_new(i),Solve_new(i+1));
        end
        
        %�γɻ�
        Cost_new=Cost_new+dist_martix(Solve_new(count),Solve_new(1));
        
        if Cost_new<Cost_current
            Cost_current=Cost_new;
            Solve_current=Solve_new;
            
            if Cost_new<Cost_best
                Cost_best=Cost_new;
                Solve_best=Solve_new;
            end
            
        else
            
            if rand<exp(-(Cost_new-Cost_current)./t)
                Cost_current=Cost_new;
                Solve_current=Solve_new;
            else
                Solve_new=Solve_current;
              
            end 
        end
        
    end
    
    %�¶�˥��
    t=t.*a;
end

disp(Solve_best);
disp(Cost_best);
        







