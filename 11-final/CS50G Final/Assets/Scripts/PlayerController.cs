using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public int lives;

    Checkpoint lastCheckPoint = null;
    AudioSource audio;

    private void Start()
    {
        audio = GetComponent<AudioSource>();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.gameObject.tag == ("OutOfBounds"))
        {
            Teleport(lastCheckPoint);
            lives--;
        }
    }

    private void Teleport(Checkpoint checkpoint)
    {
        transform.position = checkpoint.transform.position + new Vector3(0,2,0);
        GameObject particles = Resources.Load<GameObject>("Prefabs/TeleportParticles");
        GameObject go = Instantiate(particles, transform.position, Quaternion.identity);
        Destroy(go, 3);
    }

    public void SetLastCheckPoint(Checkpoint chPt)
    {
        lastCheckPoint = chPt;
    }

    public void PlaySound(AudioClip clip)
    {
        audio.PlayOneShot(clip);
    }
}
