clear;
y=randn(2,5);
y=[-1.5,2.725404224946106,0.714742903826096,-0.124144348216312,0.40903448980048;-0.03492346633185,-0.0630548731896562,-0.204966058299775,1.48969760778547,1.41719241342961];
P=digraph([1],[]);
P.Nodes.Position={[-5;-5] };
P.Nodes.Cov={diag([5 5]);};
P.Nodes.Det = {det(diag([5 5]));};


P.Nodes.Parent = {0;};
P.Nodes.Generation={0;};
Childnum_max=4;
Childnum_min=5;

generation=0;
nodestart=2;%
count=1;
tag=1; %tag=1 
recordmax=0;%
recordmaxini=0;
compare_num=6;
      
      for a1=1:Childnum_max
           generation=1;
           count=count+1;
           
           P=addedge(P,1,count);

           P.Nodes.Parent(count) = {1}; %startnum_min
           P.Nodes.Position(count) = {table2array(P.Nodes.Position( table2array(P.Nodes.Parent(count))))+[-1/6;0]*(a1-1-1)*(a1-1-2)*(a1-1-3)+[-1/2;0]*(a1-1)*(a1-1-2)*(a1-1-3)+[0;-1/2]*(a1-1)*(a1-1-1)*(a1-1-3)+[0;-1/6]*(a1-1)*(a1-1-1)*(a1-1-2)};
           P.Nodes.Cov(count) =  P.Nodes.Cov(1);
           P.Nodes.Det(count) = {det(table2array(P.Nodes.Cov(table2array(P.Nodes.Parent(count)))))};
           P.Nodes.Generation(count)={generation};

           record1=count;
         for a2=1:Childnum_min
           generation=2;
           count=count+1;
           
           P=addedge(P,record1,count);
           
           
           P.Nodes.Parent(count) = {record1}; %startnum_min是这个树的爹，startnum_min一开始是上一代min的第一个元素的编号
           P.Nodes.Position(count) = {table2array(P.Nodes.Position( table2array(P.Nodes.Parent(count))))};%+[-1/6;0]*(count-k-1)*(count-k-2)*(count-k-3)+[-1/2;0]*(count-k)*(count-k-2)*(count-k-3)+[0;-1/2]*(count-k)*(count-k-1)*(count-k-3)+[0;-1/6]*(count-k)*(count-k-1)*(count-k-2)};
           P.Nodes.Cov(count) = {kalmanRiccatiY(table2array(P.Nodes.Position(record1)),y(:,a2),table2array(P.Nodes.Cov(record1)))};
           P.Nodes.Det(count) = {det(table2array(P.Nodes.Cov(count)))};
           P.Nodes.Generation(count)={generation};
           
           if a1==1
               
               recordmaxini=max(recordmaxini, table2array(P.Nodes.Det(count)));
                recordmax=max([det(table2array(P.Nodes.Cov(count))) recordmax]);
                      
           else if table2array(P.Nodes.Det(count))>recordmaxini
              % P = rmedge(P,record1,count);
               break
               
               end
           
           end
           
         end
                  
      end
  
      G=plot(P)
      
      
  G.XData= [6 2.5000 1.5 2 3-0.5 3 3.5 5 4.5 5.5 6.5 6 7 8 7.5 8.5];
  G.YData=[3 2 1 1 1 1 1 2 1 1 2 1 1 2 1 1];
  
  
  det=P.Nodes.Det';
  det=cell2mat(det);
  
  det(2)=max([det(3),det(4),det(5),det(6),det(7)]);
  det(8)=det(10);
  det(11)=det(13);
    det(14)=det(16);
    det(1)=det(2);
  
  for i=1:length(det)
    aa{i}=num2str(det(i));
  end


  G.NodeLabel=aa;	
  edge1={'u1' 'u2'  'u3' 'u4'};
  edge2={'measurement1' 'measurement2' 'measurement3' 'measurement4' 'measurement5' 'measurement1' 'measurement2' 'measurement1' 'measurement2' 'measurement1' 'measurement2' };
  G.EdgeLabel=[edge1 edge2 ];
  
  highlight(G,[10 13 16],'NodeColor','r')
   highlight(G,[10 13 16],'Marker','v')
  highlight(G,[8 11 14],'NodeColor','r')
  highlight(G,8,10,'LineStyle','--')
  highlight(G,11,13,'LineStyle','--')
  highlight(G,14,16,'LineStyle','--')%??????????????
G.MarkerSize=7;