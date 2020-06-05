using UnityEngine;
using UnityEngine.UI;
using System.Collections;

[RequireComponent(typeof(Text))]
public class PointsText : MonoBehaviour {

	public GameObject helicopter;
	private Text text;
	private int points;

	// Use this for initialization
	void Start () {
		text = GetComponent<Text>();
	}

	// Update is called once per frame
	void Update () {
		if (helicopter != null) {
			points = helicopter.GetComponent<HeliController>().pointsTotal;
		}
		text.text = "Points: " + points;
	}
}
