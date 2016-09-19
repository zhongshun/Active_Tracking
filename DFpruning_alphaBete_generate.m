function  nodenext=alphaBeta_generate(Count,GraphName,End_Generation,Max_Children, Min_Children)%genearate the next node by deepth first
   % var bestValue;
   DF=GraphName;
    if DF.Nodes.Finish(Count)==0 %The node is not finish, countinue genearte the next part of the node;
        
         parent=Count;
         
         DF=addedge(DF,parent,Count+1); 
         DF.Nodes.Children(parent)= DF.Nodes.Children(parent)+1;
         DF.Nodes.Parent(Count+1)=parent;
         DF.Nodes.Generation(Count+1)= DF.Nodes.Generation(parent)+1;
         DF.Nodes.Law(Count+1)=~DF.Nodes.Law(parent);
        
           if  DF.Nodes.Law(parent)==0;
                Childrennum=Min_Children;
                DF.Nodes.Position(Count+1) = {table2array(DF.Nodes.Position(parent))+[-1/6;0]*(DF.Nodes.Children(parent)-2)*(DF.Nodes.Children(parent)-3)*(DF.Nodes.Children(parent)-4)+[-1/2;0]*(DF.Nodes.Children(parent)-1)*(DF.Nodes.Children(parent)-3)*(DF.Nodes.Children(parent)-4)+[0;-1/2]*(DF.Nodes.Children(parent)-1)*(DF.Nodes.Children(parent)-2)*(DF.Nodes.Children(parent)-4)+[0;-1/6]*(DF.Nodes.Children(parent)-1)*(DF.Nodes.Children(parent)-2)*(DF.Nodes.Children(parent)-3)};        
                DF.Nodes.Cov(Count+1) = DF.Nodes.Cov(parent);
                DF.Nodes.Det(Count+1) = det(table2array(DF.Nodes.Cov(Count+1)));
           else
               Childrennum=Max_Children;
               DF.Nodes.Position(Count+1) = DF.Nodes.Position(parent);
               DF.Nodes.Cov(Count+1) = {kalmanRiccatiY(table2array(DF.Nodes.Position(parent)),y(:,DF.Nodes.Children(parent)),table2array(DF.Nodes.Cov(parent)))};         
               DF.Nodes.Det(Count+1) = det(table2array(DF.Nodes.Cov(Count+1)));
           end

           if nnz(successors(DF,parent))>=Childrennum  %the number of children is equal the number we want, mark the node as finished
               DF.Nodes.Finish(parent)=1;
           end
           
            if DF.Nodes.Generation(Count+1)>=End_Generation  %reach the last generation
               DF.Nodes.Finish(Count+1)=1;             
            else 
               DF.Nodes.Finish(Count+1)=0;
            end
           nodenext=count+1;
         
           
     else %this node is finished, not need to go deeper      
           parent=Count;
            while DF.Nodes.Finish(parent)%to go to the upper part to find the node that is not finished. if all done break;
                parent=DF.Nodes.Parent(parent);
                if parent==1
                  break;
                end
            end
            DF=addedge(DF,parent,Count+1); 
            DF.Nodes.Children(parent)= DF.Nodes.Children(parent)+1;
            DF.Nodes.Parent(Count+1)=parent;
            DF.Nodes.Generation(Count+1)= DF.Nodes.Generation(parent)+1;
            DF.Nodes.Law(Count+1)=~DF.Nodes.Law(parent);
            
            if  DF.Nodes.Law(parent)==0;
                Childrennum=Min_Children;
                DF.Nodes.Position(Count+1) = {table2array(DF.Nodes.Position(parent))+[-1/6;0]*(DF.Nodes.Children(parent)-2)*(DF.Nodes.Children(parent)-3)*(DF.Nodes.Children(parent)-4)+[-1/2;0]*(DF.Nodes.Children(parent)-1)*(DF.Nodes.Children(parent)-3)*(DF.Nodes.Children(parent)-4)+[0;-1/2]*(DF.Nodes.Children(parent)-1)*(DF.Nodes.Children(parent)-2)*(DF.Nodes.Children(parent)-4)+[0;-1/6]*(DF.Nodes.Children(parent)-1)*(DF.Nodes.Children(parent)-2)*(DF.Nodes.Children(parent)-3)};
                DF.Nodes.Cov(Count+1) = DF.Nodes.Cov(parent);
                DF.Nodes.Det(Count+1) = det(table2array(DF.Nodes.Cov(Count+1)));

                
           else
               Childrennum=Max_Children;
               DF.Nodes.Position(Count+1) = DF.Nodes.Position(parent);
               DF.Nodes.Cov(Count+1) = {kalmanRiccatiY(table2array(DF.Nodes.Position(parent)),y(:,DF.Nodes.Children(parent)),table2array(DF.Nodes.Cov(parent)))};         
               DF.Nodes.Det(Count+1) = det(table2array(DF.Nodes.Cov(Count+1)));

           if DF.Nodes.Children(parent)>=Childrennum %?????????????????
                DF.Nodes.Finish(parent)=1;
           %     highlight(DF,parent,'NodeColor','g')
           end
         
            if DF.Nodes.Generation(Count+1)>=End_Generation %????????????
             DF.Nodes.Finish(Count+1)=1;             
            else 
             DF.Nodes.Finish(Count+1)=0;
            end
            nodenext=count+1;
     end
                 
    end
         

end