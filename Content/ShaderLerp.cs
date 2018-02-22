using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShaderLerp : MonoBehaviour {

	public Text text;
	public float handler;
	public bool grow;
	public bool dissolve;

	
	public float secondDuration;
	
	// Update is called once per frame
	void Update () 
	{
		if (grow)
		{	
			float fragmentation = 1	 / secondDuration;
			handler += fragmentation * Time.deltaTime;
			
			if (handler > 1)
				grow = false;
		}

		if (dissolve)
		{
			float fragmentation = -1 / secondDuration;
			handler += fragmentation * Time.deltaTime;
			
			if (handler < 0)
				dissolve = false;
		}

		Shader.SetGlobalFloat ("_Dissolve", handler);
	}

	public void Dissolve ()
	{
		handler = 1;
		dissolve = true;
		grow = false;
	}

	public void Grow ()
	{
		handler = 0;
		dissolve = false;
		grow = true;
	}

	public void SetDuration (float duration)
	{
		secondDuration = duration;
		text.text = duration.ToString();
	}
}
