
import os
from rewind7am import rewindTime


def take_note(n, T):
    # allows the user to simply record a note, saves it together with unix time in notes/
    # n = input("Enter note: ")
    # if len(sys.argv) > 1:
    #     T = sys.argv[1]
    # else:
    # T = int(time.time())

    os.chdir("../")
    logfile = "logs/notes_" + str(rewindTime(int(T))) + ".txt"
    if os.path.exists(logfile):
        print("EXISTS")
        append_write = 'a'  # append if already exists
    else:
        print("DOESNT EXISTS")
        # make a new file if notcurpath = os.path.abspath(os.curdir)
        append_write = 'w'

    file = open(logfile, append_write)
    file.write(str(T) + " " + n + "\n")
    file.close()
    print("logged note: " + str(T) + " " + n + " into " + logfile)
