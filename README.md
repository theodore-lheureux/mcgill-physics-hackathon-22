<h1>McGill Physics Hackathon 2022: Lagrange Points Visualizer</h1>

## Authors
- [Eric Deng](https://github.com/Lawnless1)
- [Maxime Gagnon](https://github.com/Thurinum)
- [Kenneth Chen](https://github.com/)
- [David Vo](https://github.com/)
- [Theodore l'Heureux](https://duckduckgo.com)

<h2>Features highlights</h2>

<ul>
	<li>
		Visualize Lagrange points in a system of two astral bodies.
	</li>
	<li>
		Control <strong>simulation speed</strong>,
		<strong>mass of bodies</strong>,
		<strong>distance between masses</strong>,
		<strong>velocity of the third object</strong> and
		<strong>velocity angle</strong>.
	</li>
</ul>

<h2>Where it comes from</h2>

<p>
	We were intrigued by the numerous applications of Lagrange points in
	real-world contexts such as space exploration, satellites, and telescopes.
	As such, we wanted to gain a better intuitive and visual understanding of
	Lagrange points by developing an interactive application to facilitate
  their vizualisation.
</p>

<h2>What it does</h2>

<p>
	Welcome to our Lagrange point simulator for the McGill Physics Hackathon
	2022. It calculates the five Lagrange points of two massive objects and the
	trajectories of small-mass bodies in such a system. Within our interactive
	application, you may modify the mass of the two massive objects and the
	distance between them. The speed of the simulation can also be changed to
	see how small-mass bodies are affected by the gravity of the two large
	bodies over a long period of time.
</p>

<h2>How we built it</h2>

<p>
	The mathematical backend behind the visualizer is in Python, whereas the
	accompanying graphical user interface is written in QML and powered by Qt's
	stable and performant GUI technology. Interfacing between the UI and business
	logic is achieved thanks to the PySide6 bindings.
</p>

<h2>Challenges we faced</h2>

<p>
	Implementing 5 Lagrange point equations was quite a challenge, as it
	required the solving of a quintic function. We overcame this challenge by
	finding an approximation for each Lagrange point, that is valid as long as the 
  mass ratio between the two masses did not reach a certain limit.
</p>

<p>
	Centering the simulation around the barycenter (which is the center of mass
	of two bodies that orbit one another) was challenging, as the Lagrange point
	locations found with the equations are with respect to one of the masses,
	and not the barycenter.
</p>

<h2>Accomplishments that we're proud of</h2>

<p>
	We are proud that we succeeded in creating a simulator that allowed us to
	understand in an intuitive way what Lagrange points are, which were
	previously a nebulous math-heavy, hard-to-imagine, concept. We are proud
	that we pulled together our barebones knowledge of coding and learned new
	languages and new methods to create something we can actually concretely see
	and use.
</p>

<h2>What we learned</h2>

<p>
	Although we all had a rough idea of what Lagrange points were, we deepened
	our understanding on the subject by diving into what exactly governed the
	motion of objects in a two-mass-body system through extensive research on
	Newtonian physics. We gained an intuition on how Lagrange points actually
	work.
</p>

<p>
	We also learned how to create a project under time-sensitive constraints. We
	figured out of to allocate tasks equally so that each team member could
	fulfill their role to the best of their abilities. For example,
	physics-oriented team members focused on the backend of the project,
	calculating the Lagrange points, whereas more proficient programmers focused
	on the frontend and built the GUI and the simulator interface.
</p>

<p>
	The choice of what framework to use for building the graphical component of
	our visualizer was also a hard one to make. We had originally planned to use
	<em>pygame</em> for that purpose, but decided to go for Qt Quick using QML
	as it is a more mature and high-level framework for designing performant and
	appealing GUIs.
</p>

<p>
	We thus learned how to use QML to visualize the objects. We had no
	experience with the language but believe we did a good job utilizing the 24h
	to implement as best we could the features we wanted using this novel
	language for us. Qt/QML is now a new tool we have at our disposal when we
	will code in the future.
</p>

<h2>What's next for Space Lagrange Point Simulator</h2>

<ol>
	<li>Enhancing stability of the simulation</li>
	<li>Adding better collision handling</li>
	<li>Adding an arbitrary number of objects to the scene</li>
	<li>Re-writing in Qt C++</li>
</ol>

## How to run
Open a command line prompt in the project's directory.

```ps
pip install pyqt6
pip install pyside6
python main.py
```

## Credits
- Uses Qt Quick with PySide6 bindings for Python


