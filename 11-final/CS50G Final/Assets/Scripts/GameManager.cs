using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public GameState gState;
    public enum GameState { pause, play, gameover}

    public GameObject pausePanel;
    public GameObject gameOverPanel;
    public GameObject winPanel;
    public Text txtTimer;
    public float goalTime;
    public float timeLeft;
    public Text txtLives;

    public AudioSource gameMusic;
    public AudioSource efxMusic;

    PlayerController player;

    void Start()
    {
        gState = GameState.pause;
        gameMusic.Pause();
        efxMusic.clip = Resources.Load<AudioClip>("Sounds/waiting");
        efxMusic.loop = true;
        efxMusic.Play();
        timeLeft = goalTime;
        txtTimer.text = timeLeft.ToString();

        player = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>();
        txtLives.text = player.lives.ToString();
    }

    // Update is called once per frame
    void Update()
    {
        if (gState == GameState.play)
        {
            if (Input.GetButtonDown("Pause"))
            {
                Pause();
            }
            timeLeft -= Time.deltaTime;
            txtTimer.text = Mathf.Floor(timeLeft).ToString();
            txtLives.text = player.lives.ToString();
        }

        if (gState == GameState.play && (timeLeft <= 0 || player.lives <= 0))
        {
            GameOver();
        }
    }

    public void ReturnToMenu()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene("Title");
    }

    public void Pause()
    {
        pausePanel.SetActive(true);
        gameMusic.Pause();
        efxMusic.clip = Resources.Load<AudioClip>("Sounds/waiting");
        efxMusic.loop = true;
        efxMusic.Play();
        gState = GameState.pause;
        Time.timeScale = 0;        
    }

    public void Resume()
    {
        pausePanel.SetActive(false);
        efxMusic.loop = false;
        efxMusic.Stop();
        Time.timeScale = 1;
        gState = GameState.play;
        gameMusic.UnPause();
    }

    public void Restart()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }

    public void GameOver()
    {
        gameOverPanel.SetActive(true);
        gState = GameState.gameover;
    }

    public void Win()
    {
        winPanel.SetActive(true);
        gState = GameState.gameover;
    }

    public void NextLevel(string scene)
    {
        SceneManager.LoadScene(scene);
    }
}