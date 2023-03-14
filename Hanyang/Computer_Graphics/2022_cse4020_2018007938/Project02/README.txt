2018007938 김민관

a) UI for control point specification
  	1. If click a cow in first time, then change drag mode to Horizontal Drag mode. Cow will follow mouse's movement.
  	2. If click a cow long time, change drag mode to Vertical Drage mode. Cow will also follow mouse's movement.
  	3. If click again or release mouse, cow's current location will save and go back to 1 step. 
  	4. If 6 cow's location is selected, then cow rollercoster will start 3 times.
  	5. If cow rollercoster is finished, cow will move back to first saved location.
  
b) Vertical Dragging (L-drag), Horizontal positioning.
	1. In onMouseButton(window,button, state, mods) function
		1-1. Selected cow's location is saved on new array 'tmpcow2wld'.
		1-2. After drag mode is active and mouse button is clicked, then save cow's location information to 'cow2wldList'. Count down until 6 cow's location is saved.
	2. In onMouseDrag(window, x, y)
		2-1. Same as on onMouseButton(window,button, state, mods) function's 1-1, 1-2.
		2-2. Add this two part to move only in y-axis.
		     -->
		     	currentCowLocation = currentPos
                     	cowPickLocalPos=transform(np.linalg.inv(cow2wld),currentPos)
                     
        3. After 6 cow is selected, start cow rollercoster animation.
        
c) Catmull-Rom spline curve
	1. Make Catmull_ROM variation.
		-->
			Catmull_ROM = np.array([[2,-2,1,1],[-3,3,-2,-1],[0,0,1,0],[1,0,0,0]]) @ np.array([[0,1,0,0],[0,0,1,0],[-0.5,0,0.5,0],[0,-0.5,0,0.5]]) 
	   		(In 13 lecture, 62page)
	   		
	2. Get time from 'get_time()' function and if 'RollerCosterTime' is over 18seconds(6 seconds x 3 times) stop animation.
	
d), e) Cow's face Foward and Face upward when going up
	In display() function
	1. Get direction vector of moving cow in time t and get get new vector 'DirectVector'
		--> Direct = np.array([3*t*t, 2*t, 1, 0]) @ Catmull_ROM @ P
	2. Use cross product to get cow's local coordinate
            	-->
			x_axis = DirectVector
			z_axis = np.cross(DirectVector, np.array([0,1,0]))
			y_axis = np.cross(z_axis, x_axis)
        3. Make 3x3 matrix to 4x4 matrix and multiply 'cow2wld' matrix and put in 'drawCow' function.
        	-->
		    nM = np.array([[nx_axis[0] , ny_axis[0], nz_axis[0], 0],
		    [nx_axis[1] , ny_axis[1], nz_axis[1], 0],
		    [nx_axis[2] , ny_axis[2], nz_axis[2], 0],
		    [0,0,0,1]])
        	--> 
			CowRun = cow @ COW.T @ np.linalg.inv(nM).T
			drawCow(CowRun, False)	
	
