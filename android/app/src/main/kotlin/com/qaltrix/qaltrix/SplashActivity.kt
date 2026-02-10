package com.qaltrix.qaltrix // Make sure this matches your package name

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.VideoView

class SplashActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val videoView = VideoView(this)
        setContentView(videoView)

        // Load video from res/raw folder
        val videoUri = Uri.parse("android.resource://$packageName/${R.raw.splash}") 
        videoView.setVideoURI(videoUri)

        // Disable media controls
        videoView.setMediaController(null)

        // When video completes, go to MainActivity
        videoView.setOnCompletionListener {
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }

        // Start the video
        videoView.start()
    }
}
