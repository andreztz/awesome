test:
	Xephyr :5 & sleep 1 ; DISPLAY=:5 awesome

check:
	awesome -k
