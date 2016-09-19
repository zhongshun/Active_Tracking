function  [nodenext,GraphUpadte,BestValue]=alphaBeta_generate_2(Count,GraphName,End_Generation,Max_Children, Min_Children,y)%genearate the next node by deepth first
   % var bestValue; [Count,DF]=alphaBeta_generate(Count,DF,End_Generation,3, 2,y);plot(DF)
     GraphUpadte=GraphName;

    if GraphUpadte.Nodes.Generation(Count) == End_Generation
                        parent=Count;
                        
                       GraphUpadte=addedge(GraphUpadte,parent,Count+1); 
                              %message('daozhele');
                       GraphUpadte.Nodes.Children(parent)= GraphUpadte.Nodes.Children(parent)+1;
                       GraphUpadte.Nodes.Parent(Count+1)=parent;
                       GraphUpadte.Nodes.Generation(Count+1)= GraphUpadte.Nodes.Generation(parent)+1;
                       GraphUpadte.Nodes.Law(Count+1)=~GraphUpadte.Nodes.Law(parent);
                       GraphUpadte.Nodes.rid(Count+1)=0;
                       GraphUpadte.Nodes.Finish(Count+1)=1;
                        
                        GraphUpadte.Nodes.Position(Count+1) = GraphUpadte.Nodes.Position(parent);
               
                        GraphUpadte.Nodes.Y(Count+1) = {UpdateY(table2array(GraphUpadte.Nodes.Position(Count+1)),y(:,GraphUpadte.Nodes.Children(parent)),table2array(GraphUpadte.Nodes.Cov(parent)))};
                        GraphUpadte.Nodes.Cov(Count+1) = {kalmanRiccatiCov(table2array(GraphUpadte.Nodes.Position(parent)),table2array(GraphUpadte.Nodes.Y(parent)),table2array(GraphUpadte.Nodes.Cov(parent)))};         
               
                        GraphUpadte.Nodes.trace(Count+1) = trace(table2array(GraphUpadte.Nodes.Cov(Count+1)));
                
                        GraphUpadte.Nodes.alpha(Count+1)=GraphUpadte.Nodes.alpha(parent);
                        GraphUpadte.Nodes.beta(Count+1) = GraphUpadte.Nodes.beta(parent);
                        GraphUpadte.Nodes.BestValue(Count+1) = GraphUpadte.Nodes.BestValue(parent);

                        nodenext= Count+1;
        
    elseif GraphUpadte.Nodes.Finish(Count)==0 %The node is not finish, Countinue genearte the next part of the node;
        
         parent=Count;
         
         
         GraphUpadte=addedge(GraphUpadte,parent,Count+1); 
         %message('daozhele');
         GraphUpadte.Nodes.Children(parent)= GraphUpadte.Nodes.Children(parent)+1;
         GraphUpadte.Nodes.Parent(Count+1)=parent;
         GraphUpadte.Nodes.Generation(Count+1)= GraphUpadte.Nodes.Generation(parent)+1;
         GraphUpadte.Nodes.Law(Count+1)=~GraphUpadte.Nodes.Law(parent);
         GraphUpadte.Nodes.rid(Count+1)=0;
         

          
           if  GraphUpadte.Nodes.Law(parent)==0%Min_Children=4;
                Childrennum=Min_Children;
                GraphUpadte.Nodes.Position(Count+1) = {table2array(GraphUpadte.Nodes.Position(parent))+[-1/6;0]*(GraphUpadte.Nodes.Children(parent)-2)*(GraphUpadte.Nodes.Children(parent)-3)*(GraphUpadte.Nodes.Children(parent)-4)+[-1/2;0]*(GraphUpadte.Nodes.Children(parent)-1)*(GraphUpadte.Nodes.Children(parent)-3)*(GraphUpadte.Nodes.Children(parent)-4)+[0;-1/2]*(GraphUpadte.Nodes.Children(parent)-1)*(GraphUpadte.Nodes.Children(parent)-2)*(GraphUpadte.Nodes.Children(parent)-4)+[0;-1/6]*(GraphUpadte.Nodes.Children(parent)-1)*(GraphUpadte.Nodes.Children(parent)-2)*(GraphUpadte.Nodes.Children(parent)-3)};        
                GraphUpadte.Nodes.Cov(Count+1) = GraphUpadte.Nodes.Cov(parent);
                GraphUpadte.Nodes.trace(Count+1) = trace(table2array(GraphUpadte.Nodes.Cov(Count+1)));
                GraphUpadte.Nodes.Y(Count+1) = GraphUpadte.Nodes.Y(parent);

                GraphUpadte.Nodes.alpha(Count+1)=GraphUpadte.Nodes.alpha(parent);
                GraphUpadte.Nodes.beta(Count+1) = GraphUpadte.Nodes.beta(parent);
                GraphUpadte.Nodes.BestValue(Count+1) = GraphUpadte.Nodes.BestValue(parent);
                
                 
           else
               Childrennum=Max_Children;%Max_Children=5;
               GraphUpadte.Nodes.Position(Count+1) = GraphUpadte.Nodes.Position(parent);
               
               GraphUpadte.Nodes.Y(Count+1) = {UpdateY(table2array(GraphUpadte.Nodes.Position(Count+1)),y(:,GraphUpadte.Nodes.Children(parent)),table2array(GraphUpadte.Nodes.Cov(parent)))};
               GraphUpadte.Nodes.Cov(Count+1) = {kalmanRiccatiCov(table2array(GraphUpadte.Nodes.Position(parent)),table2array(GraphUpadte.Nodes.Y(parent)),table2array(GraphUpadte.Nodes.Cov(parent)))};         
               
               GraphUpadte.Nodes.trace(Count+1) = trace(table2array(GraphUpadte.Nodes.Cov(Count+1)));
               
               GraphUpadte.Nodes.alpha(Count+1)=GraphUpadte.Nodes.alpha(parent);
               GraphUpadte.Nodes.beta(Count+1) = GraphUpadte.Nodes.beta(parent);
               GraphUpadte.Nodes.BestValue(Count+1) = GraphUpadte.Nodes.BestValue(parent);
               
           end

           if nnz(successors(GraphUpadte,parent))>=Childrennum  %the number of children is equal the number we want, mark the node as finished
               GraphUpadte.Nodes.Finish(parent)=1; 
               if  ~mod(GraphUpadte.Nodes.Generation(parent),2) && parent ~= 1
                 GraphUpadte.Nodes.BestValue(parent)=GraphUpadte.Nodes.alpha(parent);
               else
                 GraphUpadte.Nodes.BestValue(parent)=GraphUpadte.Nodes.beta(parent);  
               end
           end
           
            if GraphUpadte.Nodes.Generation(Count+1)>=End_Generation  %reach the last generation              
                 GraphUpadte.Nodes.Finish(Count+1)=1;      
                 GraphUpadte.Nodes.BestValue(Count+1) =  GraphUpadte.Nodes.trace(Count+1);
                 GraphUpadte.Nodes.alpha(parent) = max(GraphUpadte.Nodes.alpha(parent),GraphUpadte.Nodes.BestValue(Count+1));
                 
            else               
                 GraphUpadte.Nodes.Finish(Count+1)=0;
            end
           nodenext=Count+1;
           %go to the endgeneartion get cov
           

         
           
     else %this node is finished, not need to go deeper    GraphUpadte.Nodes.Finish(Count)==1  
           nodenext=Count+1;
           recordnode=Count;
           parent=Count;
           while GraphUpadte.Nodes.Finish(parent)%to go to the upper part to find the node that is not finished. if all done break;

                parent=GraphUpadte.Nodes.Parent(parent);
               if  ~mod(GraphUpadte.Nodes.Generation(parent),2) && parent ~= 1
                 GraphUpadte.Nodes.alpha(parent)=max(GraphUpadte.Nodes.alpha(parent),GraphUpadte.Nodes.BestValue(recordnode));
               else
                 GraphUpadte.Nodes.beta(parent)=min(GraphUpadte.Nodes.beta(parent),GraphUpadte.Nodes.BestValue(recordnode));
               end

                 if GraphUpadte.Nodes.alpha(parent)>=GraphUpadte.Nodes.beta(parent) && GraphUpadte.Nodes.Law(parent)
              GraphUpadte.Nodes.rid(parent) = 1;
              GraphUpadte.Nodes.Finish(parent) = 1;
                 end
               
               
               
                recordnode=parent;
                
                if parent==1          
                  break;
                end          
           end 
           
           if  GraphUpadte.Nodes.Children(1) > 4

                   error('It is done!!')


           end
                
           
                                    

       
            GraphUpadte=addedge(GraphUpadte,parent,Count+1); 
            GraphUpadte.Nodes.Children(parent)= GraphUpadte.Nodes.Children(parent)+1;
            GraphUpadte.Nodes.Parent(Count+1)=parent;
            GraphUpadte.Nodes.Generation(Count+1)= GraphUpadte.Nodes.Generation(parent)+1;
            GraphUpadte.Nodes.Law(Count+1)=~GraphUpadte.Nodes.Law(parent);
            GraphUpadte.Nodes.rid(Count+1)=0;
            
            if  GraphUpadte.Nodes.Law(parent)==0;%Min_Children=4;
                Childrennum=Min_Children;
                GraphUpadte.Nodes.Position(Count+1) = {table2array(GraphUpadte.Nodes.Position(parent))+[-1/6;0]*(GraphUpadte.Nodes.Children(parent)-2)*(GraphUpadte.Nodes.Children(parent)-3)*(GraphUpadte.Nodes.Children(parent)-4)+[-1/2;0]*(GraphUpadte.Nodes.Children(parent)-1)*(GraphUpadte.Nodes.Children(parent)-3)*(GraphUpadte.Nodes.Children(parent)-4)+[0;-1/2]*(GraphUpadte.Nodes.Children(parent)-1)*(GraphUpadte.Nodes.Children(parent)-2)*(GraphUpadte.Nodes.Children(parent)-4)+[0;-1/6]*(GraphUpadte.Nodes.Children(parent)-1)*(GraphUpadte.Nodes.Children(parent)-2)*(GraphUpadte.Nodes.Children(parent)-3)};
                GraphUpadte.Nodes.Cov(Count+1) = GraphUpadte.Nodes.Cov(parent);
                GraphUpadte.Nodes.trace(Count+1) = trace(table2array(GraphUpadte.Nodes.Cov(Count+1)));
                GraphUpadte.Nodes.Y(Count+1) = GraphUpadte.Nodes.Y(parent);
                
               GraphUpadte.Nodes.alpha(Count+1)=GraphUpadte.Nodes.alpha(parent);
               GraphUpadte.Nodes.beta(Count+1) = GraphUpadte.Nodes.beta(parent);
               GraphUpadte.Nodes.BestValue(Count+1) = GraphUpadte.Nodes.BestValue(parent);
                
           else
               Childrennum=Max_Children;
               GraphUpadte.Nodes.Position(Count+1) = GraphUpadte.Nodes.Position(parent);
               
               GraphUpadte.Nodes.Y(Count+1) = {UpdateY(table2array(GraphUpadte.Nodes.Position(Count+1)),y(:,GraphUpadte.Nodes.Children(parent)),table2array(GraphUpadte.Nodes.Cov(parent)))};
               GraphUpadte.Nodes.Cov(Count+1) = {kalmanRiccatiCov(table2array(GraphUpadte.Nodes.Position(parent)),table2array(GraphUpadte.Nodes.Y(parent)),table2array(GraphUpadte.Nodes.Cov(parent)))};         

               GraphUpadte.Nodes.trace(Count+1) = trace(table2array(GraphUpadte.Nodes.Cov(Count+1)));

               GraphUpadte.Nodes.alpha(Count+1)=GraphUpadte.Nodes.alpha(parent);
               GraphUpadte.Nodes.beta(Count+1) = GraphUpadte.Nodes.beta(parent);
               GraphUpadte.Nodes.BestValue(Count+1) = GraphUpadte.Nodes.BestValue(parent);
               
            end  

           if nnz(successors(GraphUpadte,parent))>=Childrennum %?????????????????
                GraphUpadte.Nodes.Finish(parent)=1;
           %     highlight(GraphUpadte,parent,'NodeColor','g')
               if  ~mod(GraphUpadte.Nodes.Generation(parent),2) && parent ~= 1
                 GraphUpadte.Nodes.BestValue(parent)=GraphUpadte.Nodes.alpha(parent);
               else
                 GraphUpadte.Nodes.BestValue(parent)=GraphUpadte.Nodes.beta(parent);  
               end
           end
         
            if GraphUpadte.Nodes.Generation(Count+1)>=End_Generation %????????????
             GraphUpadte.Nodes.Finish(Count+1)=1;   
             
             GraphUpadte.Nodes.BestValue(Count+1) =  GraphUpadte.Nodes.trace(Count+1);
             GraphUpadte.Nodes.alpha(parent) = max(GraphUpadte.Nodes.alpha(parent),GraphUpadte.Nodes.BestValue(Count+1));
             GraphUpadte.Nodes.BestValue(parent)=GraphUpadte.Nodes.alpha(parent);
             
            else 
             GraphUpadte.Nodes.Finish(Count+1)=0;
            end
            
            
            
    end
    
      BestValue=GraphUpadte.Nodes.BestValue(Count+1);

         if GraphUpadte.Nodes.alpha(parent)>=GraphUpadte.Nodes.beta(parent) && GraphUpadte.Nodes.Law(parent)
              GraphUpadte.Nodes.rid(parent) = 1;
              GraphUpadte.Nodes.Finish(parent) = 1;
              
              %make the children node of this rid node as finished

               
         end

         

         
      if  GraphUpadte.Nodes.Children(1) > 4

                   error('It is done!!')

      end   


        
end