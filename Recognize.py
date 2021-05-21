import datetime
import os
import time
import cv2
import pandas as pd

folder = "Uploads"

#-------------------------
def recognize_attendence():
    recognizer = cv2.face.LBPHFaceRecognizer_create()  # cv2.createLBPHFaceRecognizer()
    recognizer.read("TrainingImageLabel"+os.sep+"Trainner.yml")
    harcascadePath = "haarcascade_frontalface_default.xml"
    faceCascade = cv2.CascadeClassifier(harcascadePath)
    df = pd.read_csv("StudentDetails"+os.sep+"StudentDetails.csv")
    font = cv2.FONT_HERSHEY_SIMPLEX
    col_names = ['Id', 'Name', 'Date', 'Time']
    attendance = pd.DataFrame(columns=col_names)

    for filename in os.listdir(folder):
        im = cv2.imread(os.path.join(folder,filename))
        gray = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
        faces = faceCascade.detectMultiScale(gray, 1.2, 5,flags = cv2.CASCADE_SCALE_IMAGE)
        for(x, y, w, h) in faces:
            cv2.rectangle(im, (x, y), (x+w, y+h), (10, 159, 255), 2)
            Id, conf = recognizer.predict(gray[y:y+h, x:x+w])

            if conf < 100:

                aa = df.loc[df['Id'] == Id]['Name'].values
                confstr = "  {0}%".format(round(100 - conf))
                tt = str(Id)+"-"+aa


            else:
                Id = '  Unknown  '
                tt = str(Id)
                confstr = "  {0}%".format(round(100 - conf))

            if (100-conf) > 67:
                ts = time.time()
                date = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d')
                timeStamp = datetime.datetime.fromtimestamp(ts).strftime('%H:%M:%S')
                aa = str(aa)[2:-2]
                attendance.loc[len(attendance)] = [Id, aa, date, timeStamp]

            tt = str(tt)[2:-2]
            if(100-conf) > 67:
                tt = tt + " [Pass]"
                cv2.putText(im, str(tt), (x+5,y-5), font, 1, (255, 255, 255), 2)
            else:
                cv2.putText(im, str(tt), (x + 5, y - 5), font, 1, (255, 255, 255), 2)

            if (100-conf) > 67:
                cv2.putText(im, str(confstr), (x + 5, y + h - 5), font,1, (0, 255, 0),1 )
            elif (100-conf) > 50:
                cv2.putText(im, str(confstr), (x + 5, y + h - 5), font, 1, (0, 255, 255), 1)
            else:
                cv2.putText(im, str(confstr), (x + 5, y + h - 5), font, 1, (0, 0, 255), 1)



        attendance = attendance.drop_duplicates(subset=['Id'], keep='first')
        if (cv2.waitKey(1) == ord('q')):
            break
    ts = time.time()
    date = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d')
    timeStamp = datetime.datetime.fromtimestamp(ts).strftime('%H:%M:%S')
    Hour, Minute, Second = timeStamp.split(":")
    fileName = "Attendance"+os.sep+"Attendance_"+date+"_"+Hour+"-"+Minute+"-"+Second+".csv"
    attendance.to_csv(fileName, index=False)
    print("Attendance Successful")
    cv2.destroyAllWindows()
    deleteExtras()

def deleteExtras():
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print('Fai\led to delete %s. Reason: %s' % (file_path, e))