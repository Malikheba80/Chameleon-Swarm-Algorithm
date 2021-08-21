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

% This function initialize the first population of chameleons
function pos=initialization(searchAgents,dim,u,l)

% This function initialize the first population of search agents
Boundary_no= size(u,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a signle
% number for both u and l
if Boundary_no==1
    u_new=ones(1,dim)*u;
    l_new=ones(1,dim)*l;
else
     u_new=u;
     l_new=l;   
end

% If each variable has a different l and u
    for i=1:dim
        u_i=u_new(i);
        l_i=l_new(i);
        pos(:,i)=rand(searchAgents,1).*(u_i-l_i)+l_i;
    end

% pos=pos';


% 
% % number of boundaries
% Bound_no= size(u,1); 
% 
% % If the boundaries of all variables are equal, and user enters a signle number for both u and l
% if Bound_no==1
%     pos=rand(searchAgents,dim).*(u-l)+l;
% end
% 
% % If each variable has a different boundary l and u
% if Bound_no>1
%     for i=1:dim
%         u_i=u(i);
%         l_i=l(i);
%         pos(:,i)=rand(searchAgents,1).*(u_i-l_i)+l_i;
%     end
% end

