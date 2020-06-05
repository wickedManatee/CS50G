using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Checkpoint : MonoBehaviour
{
    public CheckPointType cType;
    public enum CheckPointType { Start, Save, Goal }

    GameManager mgr;
    PlayerController player;

    private void Start()
    {
        mgr = GameObject.FindGameObjectWithTag("GameController").GetComponent<GameManager>();
        player = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>();
        if (cType == CheckPointType.Start)
        {
            player.SetLastCheckPoint(this);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            player.SetLastCheckPoint(this);
            
            if (cType == CheckPointType.Start)
                mgr.Resume();
            else if (cType == CheckPointType.Goal)
                mgr.Win();
            else
            {
                AudioClip clip = Resources.Load<AudioClip>("Sounds/pickup");
                player.PlaySound(clip);
            }
        }
    }
}
