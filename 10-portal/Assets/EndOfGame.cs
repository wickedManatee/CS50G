using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EndOfGame : MonoBehaviour
{
    public GameObject winText;
    public GameObject ethan;

    private void Start()
    {
        winText.SetActive(false);
        ethan.GetComponent<Animator>().SetBool("Crouch", true);
    }

    private void OnTriggerEnter(Collider other)
    {
        ethan.GetComponent<Animator>().SetBool("Crouch", false);
        winText.SetActive(true);
        StartCoroutine(Restart());
    }

    private IEnumerator Restart()
    {
        yield return new WaitForSeconds(3);
        SceneManager.LoadScene("CS50G");
    }
}
