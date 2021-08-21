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
%% % Prepare the problem
dim = 2;
ub = 50 * ones(1, 2);
lb = -50 * ones(1, 2);
fobj = @Objfun;

%% % CSA parameters 
noP = 30;
maxIter = 1000;
 

             [bestFitness, bestPosition, CSAConvCurve] =Chameleon(noP,maxIter,lb,ub,dim,fobj);

              disp(['===> The optimal fitness value found by Standard Chameleon is ', num2str(bestFitness, 15)]);
% %% % Draw the objective space
% 
% figure;  set(gcf,'color','w');
% 
% plot(CSAConvCurve,'LineWidth',2,'Color','b'); grid;
% title({'Objective space','(Convergence characteristic)'},'interpreter','latex','FontName','Times','fontsize',10);
% xlabel('Iteration','interpreter','latex','FontName','Times','fontsize',10)
% ylabel('Best score obtained so far','interpreter','latex','FontName','Times','fontsize',10); 
% 
% axis tight; grid on; box on 
%      
% h1=legend('Chameleon','location','northeast');
% set(h1,'interpreter','Latex','FontName','Times','FontSize',10) 
% ah=axes('position',get(gca,'position'),...
%             'visible','off');
