from flask import Flask, jsonify, request, redirect, render_template
#from flask_restplus import Api, Resource

import os

flask_app = Flask(__name__)
flask_app.config["IMAGE_UPLOADS"] = "C:/Users/Gustavo Varollo/Desktop/Thiago/data_upload"


@flask_app.route("/upload-image", methods=["GET", "POST"])
def upload_image():
	if request.method == "POST":
		if request.files:
			image = request.files["image"]
			print(image)
			#return image.save(os.path.join(flask_app.config["IMAGE_UPLOADS"], image.filename))
			return redirect(request.url)
	return render_template("upload_image.html")


if __name__ == '__main__':
	flask_app.run()
