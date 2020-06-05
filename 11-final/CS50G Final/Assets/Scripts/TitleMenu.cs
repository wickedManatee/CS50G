using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TitleMenu : MonoBehaviour
{
    public GameObject title;
    public GameObject levelSelect;

    AudioSource audio;
    void Start()
    {
        audio = GetComponent<AudioSource>();
        title.SetActive(true);
        levelSelect.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if ((Input.GetButtonDown("Fire1") || Input.GetButtonDown("Submit")) && !levelSelect.activeSelf)
        {
            StartCoroutine(Animate());
        }
    }

    //use a coroutine so we can pause this function and wait for the animation to complete
    public IEnumerator Animate()
    {
        Animator anim = title.GetComponent<Animator>();
        anim.SetTrigger("SpinMe");
        AudioClip clip = Resources.Load<AudioClip>("Sounds/woosh");
        audio.PlayOneShot(clip);
        yield return WaitForAnim(anim);
    }

    IEnumerator WaitForAnim(Animator anim)
    {
        while (!anim.GetCurrentAnimatorStateInfo(0).IsName("Idle"))
        {
            Debug.Log("waiting for anim to finish");
        }
        yield return new WaitForSeconds(1);
        levelSelect.SetActive(true);
    }

    public void PlayLevel(string level)
    {
        SceneManager.LoadScene(level);
    }
}
