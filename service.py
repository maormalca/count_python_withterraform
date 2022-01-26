from flask import Flask
app = Flask(__name__)
counter =0
@app.route('/count')
def hello():
        global counter 
        counter=counter+1
        dic={"count":counter}

        return dic

if __name__ == "__main__":
        app.run(debug=True,port=8080,host="0.0.0.0")

