clear
y=randn(2,5);
% y=[-1.5,2.725404224946106,0.714742903826096,-0.124144348216312,0.40903448980048;-0.03492346633185,-0.0630548731896562,-0.204966058299775,1.48969760778547,1.41719241342961];


%初始化节点1
DF=digraph([1],[]);
DF.Nodes.Generation=1;
DF.Nodes.Finish=0;
DF.Nodes.Children=0;
DF.Nodes.Parent=1;
DF.Nodes.Law=0;
DF.Nodes.rid=0;

DF.Nodes.alpha=-100;
DF.Nodes.beta = 100;
DF.Nodes.BestValue=100;

DF.Nodes.Position={[-10;-10] };
DF.Nodes.Y={[mean(y(1,:));mean(y(2,:))] };

DF.Nodes.Cov={diag([1 1]);};
DF.Nodes.trace = trace(diag([1 1]));
End_Generation=5;
Count=1;
Max_Children=5;
Min_Children=4;
 bb=1;
l1=1; l2 =25; l3 = 7; l4=1; l5=1; l6=1;
             X(1) = 50;
             Y(1) = 6;
while Count <3000

[Count,DF,AAA]=alphaBeta_generate_2(Count,DF,End_Generation,Max_Children, Min_Children,y);


   if DF.Nodes.Generation(Count) == 6
                  X(Count) = l6;
                  Y(Count) = 1;
                  l6=l6+1.5;


   elseif DF.Nodes.Generation(Count) == 5
                  X(Count) = l5;
                  Y(Count) = 2;
                  l5=l5+1.5;
    elseif DF.Nodes.Generation(Count) == 4
                  X(Count) = l4;
                  Y(Count) = 3;
                  l4=l4+3.5;
            
    elseif DF.Nodes.Generation(Count) == 3
                  X(Count) = l3;
                  Y(Count) = 4;
                  l3=l3+14;
                  
    elseif DF.Nodes.Generation(Count) == 2
                  X(Count) = l2;
                  Y(Count) = 5;
                  l2=l2+23;
                  
%     elseif  DF.Nodes.Generation(Count) == 1
%              X(Count) = 50;
%              Y(Count) = 5;
    
    end

H=plot(DF,'XData',X,'YData',Y);


 axis([-10 120 0.5 6.5])
 
for i=1:Count
    if DF.Nodes.rid(i)==1
        highlight(H,i,'NodeColor','r');
    end

end
pause(0.0);
F(bb) = getframe;
bb=bb+1;
end

trace=DF.Nodes.trace';

H=plot(DF,'XData',X,'YData',Y);

for K=1:Count
    if DF.Nodes.Generation(K) == 5 
        trace(K)=0;
        for i=1:nnz(successors(DF,K))
            kk=successors(DF,K);
            trace(K)= max(trace(K),trace(kk(i)));
        
        end
%     else trace(K)=100;
    end
end


for K=1:Count
    if DF.Nodes.Generation(K) == 4 
        trace(K)=0;
        for i=1:nnz(successors(DF,K))
            kk=successors(DF,K);
            trace(K)= max(trace(K),trace(kk(i)));
        
        end
%     else trace(K)=100;
    end
end

for K=1:Count
    if DF.Nodes.Generation(K) == 3
        trace(K)=110;
        for i=1:nnz(successors(DF,K))
            kk=successors(DF,K);
            trace(K)= min(trace(K),trace(kk(i)));
        
         end
    end
end  

for K=1:Count
    if DF.Nodes.Generation(K) == 2
        trace(K)=0;
        for i=1:nnz(successors(DF,K))
            kk=successors(DF,K);
            trace(K)= max(trace(K),trace(kk(i)));
        
         end
    end
end  

for K=1:Count
    if DF.Nodes.Generation(K) == 1
        trace(K)=110;
        for i=1:nnz(successors(DF,K))
            kk=successors(DF,K);
            trace(K)= min(trace(K),trace(kk(i)));
        
         end
    end
end  

H.NodeLabel=trace;

 axis([-10 120 0.5 5.5])
for i=1:Count
    if DF.Nodes.rid(i)==1
        highlight(H,i,'NodeColor','r');
        highlight(H,i,'MarkerSize',4.2)
    end

end




[bestValue, ridnode] = alphaBeta(1, -100, 100, DF, [],End_Generation) ;
for j=1:Count
    if DF.Nodes.trace(j) ==bestValue
        break;
    end
end

 %--------------------------------------------------------------------------------------------------------------------------------
 %use to plot
 while DF.Nodes.Parent(j)~=1
      
     highlight(H,DF.Nodes.Parent(j),j,'EdgeColor','g')
     highlight(H,DF.Nodes.Parent(j),j,'LineWidth',2)
     j=DF.Nodes.Parent(j);
 end


