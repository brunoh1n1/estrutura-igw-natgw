from flask import Flask
app = Flask(__name__)

@app.route('/somar/<int:num1>/<int:num2>')
def somar(num1, num2):
    return str(num1 + num2)

if __name__ == '__main__':
    app.run(port=5000)