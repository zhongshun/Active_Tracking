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

DF.Nodes.Position={[-7;-5] };
DF.Nodes.Y={[mean(y(1,:));mean(y(2,:))] };

DF.Nodes.Cov={diag([1 1]);};
DF.Nodes.trace = trace(diag([1 1]));
End_Generation=7;
Count=1;
Max_Children=5;
Min_Children=4;
%  
% l1=1; l2 =140; l3 = 50; l4=17; l5=8;l6= 2; l7=1;
% 
%              X(1) = 500;
%              Y(1) = 7;
while Count <666415


[Count,DF,AAA]=alphaBeta_generate_2(Count,DF,End_Generation,Max_Children, Min_Children,y);

a=Count





end