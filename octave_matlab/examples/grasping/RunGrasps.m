% RunGrasps(tablefilename)
%
% Load and runs each individual grasp in the OpenRAVE window from a GraspTable file
% generated by MakeXTable

% Copyright (C) 2008-2010 Rosen Diankov, Dmitry Berenson
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
function RunGrasps(tablefilename,pausetime)

global probs
addopenravepaths_grasping();

load(tablefilename);

if( ~exist('pausetime','var') )
    pausetime = 0.5;
end

orEnvLoadScene('',1); % reset
robot.id = orEnvCreateRobot(robot.name,robot.filename);

Target.name = 'testobject';
Target.id = orEnvCreateKinBody(Target.name,targetfilename);
probs.grasp = orEnvCreateProblem('GrasperProblem', robot.name);

%% run the grasps
grasps = GraspTable;
TargTrans = reshape(orBodyGetLinks(Target.id), [3 4]);
orEnvSetOptions('collision pqp');

for i = 1:size(grasps,1)
    orEnvClose();
    contactsraw = RunGrasp(robot, grasps(i,:), Target,0);
    if( ~isempty(contactsraw) )
        contacts = sscanf(contactsraw,'%f');
        contacts = reshape(contacts, [6 length(contacts)/6]);
        DrawContacts(contacts,0.6);
        disp(sprintf('grasp %d',i));
        pause(pausetime);
    end
    pause;
end
