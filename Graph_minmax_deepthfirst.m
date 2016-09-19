clear;
y=randn(2,5);
P=digraph([1]);
P.Nodes.Position={[5;5] };
P.Nodes.Cov={diag([5 5]); };
P.Nodes.Det = {det(diag([5 5]));  };

P.Nodes.Parent = {0;};
P.Nodes.Generation={0};
generation=1;
nodestart=2;%从第二个节点开始遍历
count=1;
%G=digraph([1 1 1  1  2 2 2 2 7 7 7  7  12 12 12 12 17 17 17 17],[2 7 12 17 3 4 5 6 8 9 10 11 13 14 15 16 18 19 20 21])
% [1 1 1  1  2 2 2 2 7 7 7  7  12 12 12 12 17 17 17 17]
% [2 7 13 18 3 4 5 6 8 9 10 11 16 17 18 19 24 25 26 27]
%use function table2array() to convert the data
for u_1=1:2
    
    count=count+1;
    
    P=addedge(P,[1],[count],1) ;

    P.Nodes.Parent(count) = {0}; 
    P.Nodes.Position(count) = {table2array(P.Nodes.Position(1))+[-1/6;0]*(u_1-1)*(u_1-2)*(u_1-3)+[-1/2;0]*(u_1)*(u_1-2)*(u_1-3)+[0;-1/2]*(u_1)*(u_1-1)*(u_1-3)+[0;-1/6]*(u_1)*(u_1-1)*(u_1-2)};
    P.Nodes.Cov(count) = {diag([5 5])};
    P.Nodes.Det(count) = {det(diag([5 5]))  };
    P.Nodes.Genartion(count)={1};
       
     for u_2=0:4
         
        count=count+1; 
        P=addedge(P,[count-1],[count],1) ;
        
        P.Nodes.Parent(count) = {u_1}; 
        P.Nodes.Position(count) = P.Nodes.Position(count-1);
        P.Nodes.Cov(count) = {diag([5 5])};
        P.Nodes.Det(count) = {det(diag([5 5]))  };
        P.Nodes.Genartion(count)={1};      
     end
    
end

plot(G)