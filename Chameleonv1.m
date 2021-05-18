%% Chameleon Swarm Algorithm (CSA) source codes version 1.0
%
%  Developed in MATLAB R2018a
%
%  Author and programmer: Malik Braik
%
%         e-Mail: m_fjo@yahoo.com
%                 mbraik@bau.edu.au
%

%   Main paper:
%   Malik Sh. Braik,
%   Chameleon Swarm Algorithm: A Bio-inspired Optimizer for Solving Engineering Design Problems
%   Expert Systems with Applications
%   DOI: https://doi.org/10.1016/j.eswa.2021.114685
%____________________________________________________________________________________

function [fmin0,gPosition,cg_curve]=Chameleonv1(searchAgents,iteMax,lb,ub,dim,fobj)

%%%%* 1
if size(ub,2)==1
    ub=ones(1,dim)*ub;
    lb=ones(1,dim)*lb;
end

 %%%%% 
% if size(ub,1)==1
%     ub=ones(dim,1)*ub;
%     lb=ones(dim,1)*lb;
% end

 
 

%% Convergence curve
cg_curve=zeros(1,iteMax);
% 
% f1 =  figure (1);
% set(gcf,'color','w');
% hold on
% xlabel('Iteration','interpreter','latex','FontName','Times','fontsize',10)
% ylabel('fitness value','interpreter','latex','FontName','Times','fontsize',10); 
% grid;

%% Initial population

% chameleonPositions=initialization(searchAgents,dim,ub,lb);% Generation of initial solutions 
chameleonPositions=init(searchAgents,dim,ub,lb);% Generation of initial solutions 

%% Evaluate the fitness of the initial population
for i=1:searchAgents
     fit(i,1)=fobj(chameleonPositions(i,:));
end

%% Initalize the parameters of CSA
fitness=fit; % Initial fitness of the random positions
 
[fmin0,index]=min(fit);

chameleonBestPosition = chameleonPositions; % Best position initialization
gPosition = chameleonPositions(index,:); % initial global position

v=0.1*chameleonBestPosition;% initial velocity
 
v0=0.0*v;

%% Start CSA 
% Main parameters of CSA
rho=1;
% p1=0.85; %(Depends on the optimization problem (for real case study problems))
% p2=0.850 ; % (Depends on the optimization problem (for real case study problems))
% % %* or
p1=0.250; %(Depends on the optimization problem (for basic benchamrk test function (F1- F23)))
p2=1.50;  %(Depends on the optimization problem (for basic benchamrk test function (F1- F23)))

c1=1.75; 
c2=1.75;
gamma=1.0; 
alpha = 3.50;
beta=3.0; 
 %% Start CSA
for t=1:iteMax
a = 2590*(1-exp(-log(t))); 
omega=(1-(t/iteMax))^(rho*sqrt(t/iteMax)) ; 
mu= gamma*exp(-(alpha*t/iteMax)^beta) ;

%% Update the position of CSA (Exploration)
for i=1:searchAgents
      for j=1:dim
             if rand>=0.1
                  chameleonPositions(i,j)= chameleonPositions(i,j)+ p1*(chameleonBestPosition(i,j)-gPosition(j))*(rand())+... 
                     + p2*(gPosition(j)-chameleonPositions(i,j))*(rand());
             else
                   chameleonPositions(i,j)=    chameleonPositions(i,j)+mu*((ub(j)-lb(j))*rand+1*lb(j))*sign(rand-0.50) ;
             end 
      end   
end       

 %% Rotation of the chameleons - Update the position of CSA (Exploitation)

%%% Rotation 180 degrees in both direction or 180 in each direction
%  
for i=1:searchAgents      
          if (dim>2) 
              xmax=1;xmin=-1;
              th=round(xmin+rand(1,1)*(xmax-xmin));
              vec=get_orthonormal(dim,2);
              vecA=vec(:,1);
              vecB=vec(:,2);
              theta=(th*rand()*180)*(pi/180) ;
              Rot = RotMatrix(theta,vecA, vecB) ;
             if (theta~=0)
                V=[chameleonPositions(i,:) ]; 
                V_centre=mean(V,1); %Centre, of line
                Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates

                Vrc=[Rot*Vc']'; %Rotating centred coordinates
%                 Vruc=[Rot*V']'; %Rotating un-centred coordinates
                Vr=Vrc+ones(size(V,1),1)*V_centre; %Shifting back to original location
                 chameleonPositions(i,:)=((Vr)/1); 
 
             end
         else
              xmax=1;xmin=-1;
              th=round(xmin+rand(1,1)*(xmax-xmin));
              theta=th*rand()*180*(pi/180);
              Rot = RotMatrix(theta);
              
               if (theta~=0)
                V=[chameleonPositions(i,:) ];  
                V_centre=mean(V,1); %Centre, of line
                Vc=V-ones(size(V,1),1)*V_centre; %Centering coordinates

                Vrc=[Rot*Vc']'; %Rotating centred coordinates
                Vr=Vrc+ones(size(V,1),1)*V_centre; %Shifting back to original location
                chameleonPositions(i,:)=((Vr)/1);
               end
          end
   end   
 %%  % Chameleon velocity updates and find a food source
     for i=1:searchAgents
         for j=1:dim
               v(i,j)= omega*v(i,j)+ c1*(gPosition(j)-chameleonPositions(i,j))*rand +.... 
                   + c2*(chameleonBestPosition(i,j)-chameleonPositions(i,j))*rand;
         end
     end
     
     for i=1:searchAgents
         chameleonPositions(i,:)=chameleonPositions(i,:)+(v(i,:).^2 - v0(i,:).^2)/(2*a);
     end
    
  v0=v;
  
 %% handling boundary violations
 for i=1:searchAgents
 for j=1:dim
     if chameleonPositions(i,j)<lb(j)
        chameleonPositions(i,j)=lb(j);
     elseif chameleonPositions(i,j)>ub(j)
            chameleonPositions(i,j)=ub(j);
     end
 end
 end
 
 %% Relocation of chameleon positions (Randomization) 
for i=1:searchAgents
    ub_=sign(chameleonPositions(i,:)-ub)>0;   lb_=sign(chameleonPositions(i,:)-lb)<0;
       
    chameleonPositions(i,:)=(chameleonPositions(i,:).*(~xor(lb_,ub_)))+ub.*ub_+lb.*lb_;  %%%%%*2
    
%%%%%* 2 or 1 and 3
%     for j=1:1:dim
%          chameleonPositions(i,j)=(chameleonPositions(i,j).*(~xor(lb_(j),ub_(j))))+ub(j).*ub_(j)+lb(j).*lb_(j);   %%%%%*3
%     end

  %   if chameleonPositions(i,:)>=lb & chameleonPositions(i,:)<=ub
 
  fit(i,1)=fobj (chameleonPositions(i,:)) ;
      
            if fit(i)<fitness(i)
                 chameleonBestPosition(i,:) = chameleonPositions(i,:); % Update the best positions  
                 fitness(i)=fit(i); % Update the fitness
  %%% end
 end
end

%% Evaluate the new positions

[fmin,index]=min(fitness); % finding out the best positions  


% Updating gPosition and best fitness
if fmin < fmin0
    gPosition = chameleonBestPosition(index,:); % Update the global best positions
    fmin0 = fmin;
end

%% Print the results
%   outmsg = ['Iteration# ', num2str(t) , '  Fitness= ' , num2str(fmin0)];
%   disp(outmsg);

%% Visualize the results

   cg_curve(t)=fmin0; % Best found value until iteration t

%     if t>2
%      set(0, 'CurrentFigure', f1)
% 
%         line([t-1 t], [cg_curve(t-1) cg_curve(t)],'Color','b'); 
%         title({'Convergence characteristic curve'},'interpreter','latex','FontName','Times','fontsize',12);
%         xlabel('Iteration');
%         ylabel('Best score obtained so far');
%         drawnow 
%     end 
end
 
end