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

function [fmin0,gPosition,cg_curve]=Chameleon(searchAgents,iteMax,lb,ub,dim,fobj)

%%%%* 1
if size(ub,2)==1
    ub=ones(1,dim)*ub;
    lb=ones(1,dim)*lb;
end
 
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

chameleonPositions=initialization(searchAgents,dim,ub,lb);% Generation of initial solutions 

%% Evaluate the fitness of the initial population

fit=zeros(searchAgents,1);


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
rho=1.0;
p1=2.0;  
p2=2.0;  
c1=2.0; 
c2=1.80;  
gamma=2.0; 
alpha = 4.0;  
beta=3.0; 
 

 %% Start CSA
for t=1:iteMax
a = 2590*(1-exp(-log(t))); 
omega=(1-(t/iteMax))^(rho*sqrt(t/iteMax)) ; 
p1 = 2* exp(-2*(t/iteMax)^2);  % 
p2 = 2/(1+exp((-t+iteMax/2)/100)) ;
        
mu= gamma*exp(-(alpha*t/iteMax)^beta) ;

ch=ceil(searchAgents*rand(1,searchAgents));
%% Update the position of CSA (Exploration)
for i=1:searchAgents  
             if rand>=0.1
                  chameleonPositions(i,:)= chameleonPositions(i,:)+ p1*(chameleonBestPosition(ch(i),:)-chameleonPositions(i,:))*rand()+... 
                     + p2*(gPosition -chameleonPositions(i,:))*rand();
             else 
                 for j=1:dim
                   chameleonPositions(i,j)=   gPosition(j)+mu*((ub(j)-lb(j))*rand+lb(j))*sign(rand-0.50) ;
                 end 
              end   
end       
 %% Rotation of the chameleons - Update the position of CSA (Exploitation)

%%% Rotation 180 degrees in both direction or 180 in each direction
%  

% [chameleonPositions] = rotation(chameleonPositions, searchAgents, dim);
 
 %%  % Chameleon velocity updates and find a food source
     for i=1:searchAgents
               
        v(i,:)= omega*v(i,:)+ p1*(chameleonBestPosition(i,:)-chameleonPositions(i,:))*rand +.... 
               + p2*(gPosition-chameleonPositions(i,:))*rand;        

         chameleonPositions(i,:)=chameleonPositions(i,:)+(v(i,:).^2 - v0(i,:).^2)/(2*a);
     end
    
  v0=v;
  
 %% handling boundary violations
 for i=1:searchAgents
     if chameleonPositions(i,:)<lb
        chameleonPositions(i,:)=lb;
     elseif chameleonPositions(i,:)>ub
            chameleonPositions(i,:)=ub;
     end
 end
 
 %% Relocation of chameleon positions (Randomization) 
for i=1:searchAgents
    
    ub_=sign(chameleonPositions(i,:)-ub)>0;   
    lb_=sign(chameleonPositions(i,:)-lb)<0;
       
    chameleonPositions(i,:)=(chameleonPositions(i,:).*(~xor(lb_,ub_)))+ub.*ub_+lb.*lb_;  %%%%%*2
 
  fit(i,1)=fobj (chameleonPositions(i,:)) ;
      
      if fit(i)<fitness(i)
                 chameleonBestPosition(i,:) = chameleonPositions(i,:); % Update the best positions  
                 fitness(i)=fit(i); % Update the fitness
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
 
ngPosition=find(fitness== min(fitness)); 
g_best=chameleonBestPosition(ngPosition(1),:);  % Solutin of the problem
fmin0 =fobj(g_best);

end
