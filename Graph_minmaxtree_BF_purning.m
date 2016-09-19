clear;
y=randn(2,5);
y=[-1.34988694015652,0.725404224946106,0.714742903826096,-0.124144348216312,1.40903448980048;3.03492346633185,-0.0630548731896562,-0.204966058299775,1.48969760778547,1.41719241342961];

P=digraph([1 1 1 1],[2,3,4,5]);
P.Nodes.Position={[-5;-5] ;[-4;-5]; [-6;-5]; [-5;-4]; [-5;-6]};
P.Nodes.Cov={diag([5 5]); diag([5 5]); diag([5 5]); diag([5 5]); diag([5 5]);};
P.Nodes.Det = {det(diag([5 5])); det(diag([5 5])); det(diag([5 5])); det(diag([5 5])); det(diag([5 5]));};


P.Nodes.Rid={0; 0; 0; 0; 0};

P.Nodes.Parent = {0;1;1;1;1};
P.Nodes.Generation={0;1;1;1;1};
nodestart=2;%从第二个节点开始遍历
count=5;
tag=1; %tag=1 生成max节点。  tag=0 生成min节点
P.Nodes.max(1)=0;

number_max_node_each_generation=4;
number_min_node_each_generation=20;
genartion=2;


startnum=2.1;
tag_min=startnum;
endnum_min=20;

%use function table2array() to convert the data
while genartion <=4
    
    if tag==1 %刚算完max节点，算min节点
        record=count+1; %record the initial number of max tree 记录这个max树，这一代的第一个，以便在mintree生成的时候作为他的爹！
         
       % genartion=genartion+1;
         for i=1:number_max_node_each_generation
              
             k=count+1;
             for count=k:k+4
                P=addedge(P,fix(startnum),count) ;
                P.Nodes.Parent(count) = {fix(startnum)}; %startnum_min是这个树的爹，startnum_min一开始是上一代min的第一个元素的编号
                P.Nodes.Position(count) = {table2array(P.Nodes.Position( table2array(P.Nodes.Parent(count))))};%+[-1/6;0]*(count-k-1)*(count-k-2)*(count-k-3)+[-1/2;0]*(count-k)*(count-k-2)*(count-k-3)+[0;-1/2]*(count-k)*(count-k-1)*(count-k-3)+[0;-1/6]*(count-k)*(count-k-1)*(count-k-2)};
                P.Nodes.Cov(count) = {kalmanRiccatiY(table2array(P.Nodes.Position(fix(startnum))),y(:,count-k+1),table2array(P.Nodes.Cov(fix(startnum))))};
                P.Nodes.Det(count) = {det(table2array(P.Nodes.Cov(count)))};
                P.Nodes.Generation(count)={genartion};
                P.Nodes.Rid(count)={0};
                
                P.Nodes.max(fix(startnum))= max(table2array(P.Nodes.Det(k)),table2array(P.Nodes.Det(count)));
                
                
                 startnum=startnum+0.2;%到了最后，startnum移到了这一代的最后一个节点

             end
         end
         
          genartion=genartion+1;
         tag=0;
         number_min_node_each_generation=5*number_max_node_each_generation;
         
         
         %##########At the end on one generation，we want to find the nodes at the same location, and only keep the minimal one
         
         
    else  %tag=0，算max节点
        
            record=count+1;

       for i=1:number_min_node_each_generation
           
          
            k=count+1;
            for count=k:k+3
                
                P=addedge(P,fix(startnum),count) ;
                P.Nodes.Parent(count) = {fix(startnum)}; %startnum_min是这个树的爹，startnum_min一开始是上一代min的第一个元素的编号
                P.Nodes.Position(count) = {table2array(P.Nodes.Position( table2array(P.Nodes.Parent(count))))+[-1/6;0]*(count-k-1)*(count-k-2)*(count-k-3)+[-1/2;0]*(count-k)*(count-k-2)*(count-k-3)+[0;-1/2]*(count-k)*(count-k-1)*(count-k-3)+[0;-1/6]*(count-k)*(count-k-1)*(count-k-2)};
                P.Nodes.Cov(count) = P.Nodes.Cov(fix(startnum));
                P.Nodes.Det(count) = {det(table2array(P.Nodes.Cov(count)))};
                P.Nodes.Generation(count)={genartion};
                P.Nodes.Rid(count)={0};
                
                 startnum=startnum+0.25;%到了最后，startnum移到了这一代的最后一个节点
              
            end
       end
       
          genartion=genartion+1;
         tag=1;
         number_max_node_each_generation=4*number_min_node_each_generation;
  
    end
    
    
end

X1=[ -150 -50 50 150];
for i=1:4
    for j=1:5
        X2(j+5*(i-1))=X1(i)+19*(j-2.5);
    end
end

for i=1:20
    for j=1:4
        X3(j+4*(i-1))=X2(i)+5*(j-2);
    end
end

for i=1:80
    for j=1:5
        X4(j+5*(i-1))=X3(i)+0.95*(j-2);
    end
end



x=[0 X1 X2 X3 X4];



edge1={'u1' 'u2'  'u3' 'u4'};
edge2={'Σ1' 'Σ2' 'Σ3' 'Σ4' 'Σ5' };
edge=edge1;
for i=1:4
    edge=[edge edge2];
end
for i=1:20
    edge=[edge edge1];
end
for i=1:80
    edge=[edge edge2];
end
% x=[0 -200:100:-100 100:100:200  -200:20:-20 20:20:200 -200:5:-5 5:5:200 -200:-1 1:200];
% for g=1:5
y=[ones(1,1)*-0.5 ones(1,4)*-1 ones(1,20)*-1.7 ones(1,80)*-2.2 ones(1,400)*-2.5];
G=plot(P,'XData',x,'YData',y)
% G.Marker = 's';
% G.NodeColor = 'r';
% G.MarkerSize = 7;
% det=P.Nodes.Det';
% det=cell2mat(det);
% for i=1:length(det)
% aa{i}=num2str(det(i));
% end
% 
% 
% for i=26:105
% 
%    a(i)=max([table2array(P.Nodes.Det((i-26)*5+106)),table2array(P.Nodes.Det((i-26)*5+107)),table2array(P.Nodes.Det((i-26)*5+108)),table2array(P.Nodes.Det((i-26)*5+109)),table2array(P.Nodes.Det((i-26)*5+110))] );
%    aa{i}=num2str(a(i));
% end
% 
% for i=6:25
%     a(i)=min([a((i-6)*4+26),a((i-6)*4+27),a((i-6)*4+28),a((i-6)*4+29)]);
%     aa{i}=num2str(a(i));
% end
% 
% for i=2:5
%      a(i)=max([a((i-2)*5+6),a((i-2)*5+7),a((i-2)*5+8),a((i-2)*5+9),a((i-2)*5+10)]);
%     aa{i}=num2str(a(i));
% 
% end
% 
% a(1)=min([a(2),a(3),a(4),a(5)]);
% aa{1}=num2str(a(1));
% 

for i=1:505

   a(i)=table2array(P.Nodes.Det(i));
   aa{i}=num2str(a(i));
end

G.NodeLabel=aa;
% G.EdgeLabel=edge;

% 
% 
% 
% edge1={'u1' 'u2'  'u3' 'u4'};
% edge2={'?1' '?2' '?3' '?4' '?5' };
% edge=edge1;
% for i=1:4
%     edge=[edge edge2];
% end
% for i=1:20
%     edge=[edge edge1];
% end
% for i=1:80
%     edge=[edge edge2];
% end


