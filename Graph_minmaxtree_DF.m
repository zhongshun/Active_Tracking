clear;
y=randn(2,5);
y=[-1.34988694015652,0.725404224946106,0.714742903826096,-0.124144348216312,1.40903448980048;3.03492346633185,-0.0630548731896562,-0.204966058299775,1.48969760778547,1.41719241342961];
P=digraph([1],[]);
P.Nodes.Position={[5;5] };
P.Nodes.Cov={diag([5 5]);};
P.Nodes.Det = {det(diag([5 5]));};


P.Nodes.Parent = {0;};
P.Nodes.Generation={0;};
Childnum_max=4;
Childnum_min=5;

generation=0;
nodestart=2;%�ӵڶ����ڵ㿪ʼ����
count=1;
tag=1; %tag=1 ����max�ڵ㡣  tag=0 ����min�ڵ�


      
      for a1=1:Childnum_max
           generation=1;
           count=count+1;
           
           P=addedge(P,1,count);

           P.Nodes.Parent(count) = {1}; %startnum_min��������ĵ���startnum_minһ��ʼ����һ��min�ĵ�һ��Ԫ�صı��
           P.Nodes.Position(count) = {table2array(P.Nodes.Position( table2array(P.Nodes.Parent(count))))+[-1/6;0]*(a1-1-1)*(a1-1-2)*(a1-1-3)+[-1/2;0]*(a1-1)*(a1-1-2)*(a1-1-3)+[0;-1/2]*(a1-1)*(a1-1-1)*(a1-1-3)+[0;-1/6]*(a1-1)*(a1-1-1)*(a1-1-2)};
           P.Nodes.Cov(count) =  P.Nodes.Cov(1);
           P.Nodes.Det(count) = {det(table2array(P.Nodes.Cov(table2array(P.Nodes.Parent(count)))))};
           P.Nodes.Generation(count)={generation};

           record1=count;
         for a2=1:Childnum_min
           generation=2;
           count=count+1;
           
           P=addedge(P,record1,count);
           
           
           P.Nodes.Parent(count) = {record1}; %startnum_min��������ĵ���startnum_minһ��ʼ����һ��min�ĵ�һ��Ԫ�صı��
           P.Nodes.Position(count) = {table2array(P.Nodes.Position( table2array(P.Nodes.Parent(count))))};%+[-1/6;0]*(count-k-1)*(count-k-2)*(count-k-3)+[-1/2;0]*(count-k)*(count-k-2)*(count-k-3)+[0;-1/2]*(count-k)*(count-k-1)*(count-k-3)+[0;-1/6]*(count-k)*(count-k-1)*(count-k-2)};
           P.Nodes.Cov(count) = {kalmanRiccatiY(table2array(P.Nodes.Position(record1)),y(:,a2),table2array(P.Nodes.Cov(record1)))};
           P.Nodes.Det(count) = {det(table2array(P.Nodes.Cov(count)))};
           P.Nodes.Generation(count)={generation};
                
         end
      end
      
 G=plot(P);
 
det=P.Nodes.Det';
det=cell2mat(det);
for i=1:length(det)
    
end

a{2}= min([a(3),a(4),a(5),a(6]);
