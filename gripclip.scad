gripThickness=0.8;
gripWidth=6;
gripDepth=9;

// how much smaller is the insert than the tab itself (deducted from both sides)
tabInsertOffset = 0.5; 
// how much smaller is the tab than the gripper?
tabOffset = 0.8;
// how much additional tolerance should we deduct from the insert to make the tab fit properly?
tabFitTolerance = 0.1;

tabThickness=gripThickness;
tabWidth=gripWidth-tabOffset*2;
tabDepth=gripDepth-tabOffset*2;

tabInsertWidth=tabWidth-tabInsertOffset*2;
tabInsertDepth=tabDepth-tabInsertOffset*2;
tabInsertThickness=tabThickness*0.5;

ropeMount=false;
ropeDiameter=1.5;
ropeTubeThickness=0.3;
ropeSupportThickness=0.5;

gripHandleWidth=0.5;

module createTab(offset=0) {
	translate([0,0,tabInsertThickness]) {
		union() {
			scale([tabWidth+offset*2,tabDepth+offset*2,1]) {
				cylinder(h=tabThickness+offset*2,r=0.5,center=false,$fn=35);
			}
			translate([0,0,-tabInsertThickness-offset])
				scale([tabInsertWidth+offset*2,tabInsertDepth+offset*2,1]) {
					cylinder(h=tabInsertThickness+offset*2,r=0.5,center=false,$fn=35);
				}
		}
	}
};

module createGrip() {
	difference() {
		union() {
			scale([gripWidth,gripDepth,1]) {
				cylinder(h=gripThickness,r=0.5,center=false,$fn=35);
			}
			rotate(0,[0,0,1]) {
				scale([gripWidth+gripHandleWidth,gripWidth,gripThickness]) {
					translate([0,0,0.5]) {
						scale([0.5,0.5,0.5]) {
							minkowski() {
								cube([1,1,1],center=true);
								cylinder(r=0.5,h=1,center=true,$fn=35);
							}
						}
					}
				}
			}
		}
		createTab(tabFitTolerance);
	}
};

module createRopeTube() {
	translate([ropeSupportThickness*2,0,ropeDiameter/2+ropeTubeThickness])
	rotate(90,[1,0,0]) {
		difference() {
			union() {
				cylinder(h=gripDepth/2,r=ropeDiameter/2+ropeTubeThickness,center=true,$fn=35);
				translate([-ropeSupportThickness,-ropeDiameter/2-ropeTubeThickness+gripThickness/2,0])
					cube([ropeSupportThickness*2,gripThickness,gripDepth/2],center=true);
			}
			cylinder(h=gripDepth/2+1,r=ropeDiameter/2,center=true,$fn=35);
		}
	}

};

createGrip();
rotate(180,[0,1,0])
	translate([-gripWidth-3,0,-tabThickness-tabInsertThickness])
		createTab();
translate([gripWidth/2,0,0])
	createRopeTube();