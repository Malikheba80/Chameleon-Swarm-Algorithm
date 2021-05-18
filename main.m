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
   
clear 
close all
clc

format longe;
rng(0); % control random values generation
set(0,'defaultTextInterpreter','latex');             %trying to set the default
extraInputs = {'interpreter','latex','fontsize',11}; % name, value pairs

% Global parameters for various metaheurstic search
%***************************************************
K   = 23;    % number of function to execute.. max is 15
PopSize      = 100;   % Number of search agents
maxIteration = 1000;   % Maximum number of iterations

for k=1:K

    Function_name = sprintf('F%d',k); 
    [lb,ub,dim,fobj]= Get_Functions_details(Function_name);
      
    [Best_score_CSA,Best_pos_CSA,CSAConvCurve]=Chameleonv1(PopSize,maxIteration,lb,ub,dim,fobj);
%    [Best_score_CSA,Best_pos_CSA,CSAConvCurve]=Chameleonv2(PopSize,maxIteration,lb,ub,dim,fobj);


%% % Draw the objective space

figure;  set(gcf,'color','w');

plot(CSAConvCurve,'LineWidth',2,'Color','b'); grid;
title({'Objective space','(Convergence characteristic)'},'interpreter','latex','FontName','Times','fontsize',10);
xlabel('Iteration','interpreter','latex','FontName','Times','fontsize',10)
ylabel('Best score obtained so far','interpreter','latex','FontName','Times','fontsize',10); 

axis tight; grid on; box on 
     
h1=legend('CSA','location','northeast');
set(h1,'interpreter','Latex','FontName','Times','FontSize',10) 
ah=axes('position',get(gca,'position'),...
            'visible','off');
        
display(['Function no: ===> ', num2str(k),' ===>The optimal value located is ', num2str(Best_score_CSA,12)]);

close all
end
 